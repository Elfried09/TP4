#!/usr/bin/env python3
"""
API REST complète pour gestion des oiseaux
Supporte: GET, POST, PUT, DELETE avec MongoDB/SQLite
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import sqlite3
import urllib.parse
import re

class APIHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        """GET - Récupère les données"""
        parsed_url = urllib.parse.urlparse(self.path)
        path = parsed_url.path
        query_params = urllib.parse.parse_qs(parsed_url.query)
        
        try:
            # /api/especes - Liste toutes les espèces
            if path == '/api/especes':
                limit = int(query_params.get('limit', [100])[0])
                offset = int(query_params.get('offset', [0])[0])
                habitat_filter = query_params.get('habitat', [''])[0]
                sort_by = query_params.get('sort', ['id_espece'])[0]
                sort_order = query_params.get('order', ['asc'])[0].upper()
                
                allowed_sorts = ['id_espece', 'nom_francais', 'taille_cm', 'poids_g', 'longevite_ans', 'nombre_individus', 'nom_commun']
                sort_by = sort_by if sort_by in allowed_sorts else 'id_espece'
                sort_order = sort_order if sort_order in ['ASC', 'DESC'] else 'ASC'
                
                sort_map = {'nom_commun': 'nom_francais', 'nom_francais': 'nom_francais'}
                db_sort = sort_map.get(sort_by, sort_by)
                
                conn = sqlite3.connect('database/oiseaux.db')
                conn.row_factory = sqlite3.Row
                c = conn.cursor()
                
                query = '''SELECT id_espece, nom_francais as nom_commun, nom_scientifique, 
                          taille_cm, poids_g, habitat, statut as statut_conservation,
                          longevite_ans, nombre_individus, description, distribution,
                          (SELECT COUNT(*) FROM image WHERE image.id_espece = espece.id_espece) as nombre_images FROM espece'''
                params = []
                
                if habitat_filter:
                    query += ' WHERE habitat LIKE ?'
                    params.append(f'%{habitat_filter}%')
                
                query += f' ORDER BY {db_sort} {sort_order} LIMIT ? OFFSET ?'
                params.extend([limit, offset])
                
                c.execute(query, params)
                rows = c.fetchall()
                
                # Total
                count_q = 'SELECT COUNT(*) FROM espece'
                if habitat_filter:
                    count_q += ' WHERE habitat LIKE ?'
                    c.execute(count_q, [f'%{habitat_filter}%'])
                else:
                    c.execute(count_q)
                total = c.fetchone()[0]
                
                conn.close()
                
                data = [dict(row) for row in rows]
                self.send_json({'success': True, 'data': data, 'total': total})
            
            # /api/especes/{id} - Détails d'une espèce
            # /api/especes/{id}/images - Images d'une espèce (DOIT ÊTRE AVANT le détail)
            elif re.match(r'^/api/especes/\d+/images$', path):
                try:
                    espece_id = int(re.search(r'/api/especes/(\d+)/images', path).group(1))
                    conn = sqlite3.connect('database/oiseaux.db')
                    conn.row_factory = sqlite3.Row
                    c = conn.cursor()
                    
                    c.execute('SELECT id_image, titre, url, description FROM image WHERE id_espece = ?', 
                             (espece_id,))
                    images = [dict(row) for row in c.fetchall()]
                    conn.close()
                    
                    self.send_json({'success': True, 'images': images})
                except Exception as e:
                    self.send_json({'error': str(e)}, 400)
            
            # /api/especes/{id} - Détails d'une espèce
            elif path.startswith('/api/especes/') and path != '/api/especes/':
                espece_id = int(path.split('/')[-1])
                conn = sqlite3.connect('database/oiseaux.db')
                conn.row_factory = sqlite3.Row
                c = conn.cursor()
                
                c.execute('''SELECT id_espece, nom_francais as nom_commun, nom_scientifique,
                           taille_cm, poids_g, habitat, statut as statut_conservation,
                           longevite_ans, nombre_individus, description, distribution,
                           (SELECT COUNT(*) FROM image WHERE image.id_espece = espece.id_espece) as nombre_images FROM espece
                           WHERE id_espece = ?''', (espece_id,))
                row = c.fetchone()
                conn.close()
                
                if row:
                    self.send_json({'success': True, 'data': dict(row)})
                else:
                    self.send_json({'success': False, 'error': 'Not found'}, 404)
            
            # /api/habitats - Liste des habitats
            elif path == '/api/habitats':
                conn = sqlite3.connect('database/oiseaux.db')
                c = conn.cursor()
                c.execute('SELECT DISTINCT habitat FROM espece ORDER BY habitat')
                habitats = [row[0] for row in c.fetchall()]
                conn.close()
                
                self.send_json({'success': True, 'habitats': habitats})
            
            # /api/health
            elif path == '/api/health':
                self.send_json({'status': 'ok'})
            
            else:
                self.send_json({'error': 'Not found'}, 404)
        
        except Exception as e:
            self.send_json({'error': str(e)}, 500)
    
    def do_POST(self):
        """POST - Crée une nouvelle espèce"""
        try:
            path = urllib.parse.urlparse(self.path).path
            
            if path == '/api/especes':
                content_length = int(self.headers.get('Content-Length', 0))
                body = self.rfile.read(content_length).decode('utf-8')
                data = json.loads(body)
                
                # Valider les champs requis
                nom_francais = data.get('nom_commun', data.get('nom_francais', ''))
                nom_scientifique = data.get('nom_scientifique', '')
                
                if not nom_francais or not nom_scientifique:
                    self.send_json({'success': False, 'error': 'Missing required fields'}, 400)
                    return
                
                conn = sqlite3.connect('database/oiseaux.db')
                c = conn.cursor()
                
                # Générer un nouvel ID
                c.execute('SELECT MAX(id_espece) FROM espece')
                max_id = c.fetchone()[0]
                new_id = (max_id or 0) + 1
                
                c.execute('''INSERT INTO espece  
                          (id_espece, nom_francais, nom_scientifique, taille_cm, poids_g, habitat, 
                           statut, longevite_ans, nombre_individus, id_genre)
                          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
                         (new_id, nom_francais, nom_scientifique, 
                          data.get('taille_cm'), data.get('poids_g'),
                          data.get('habitat', ''), data.get('statut', 'LC'),
                          data.get('longevite_ans'), data.get('nombre_individus'),
                          data.get('id_genre', 1)))
                
                conn.commit()
                conn.close()
                
                self.send_json({'success': True, 'id_espece': new_id}, 201)
            else:
                self.send_json({'error': 'Not found'}, 404)
        
        except Exception as e:
            self.send_json({'success': False, 'error': str(e)}, 400)
    
    def do_DELETE(self):
        """DELETE - Supprime une espèce"""
        try:
            path = urllib.parse.urlparse(self.path).path
            
            if path.startswith('/api/especes/') and path != '/api/especes/':
                espece_id = int(path.split('/')[-1])
                
                conn = sqlite3.connect('database/oiseaux.db')
                c = conn.cursor()
                
                # Supprimer les images associées
                c.execute('DELETE FROM image WHERE id_espece = ?', (espece_id,))
                # Supprimer l'espèce
                c.execute('DELETE FROM espece WHERE id_espece = ?', (espece_id,))
                
                conn.commit()
                affected = c.rowcount
                conn.close()
                
                if affected > 0:
                    self.send_json({'success': True, 'id_espece': espece_id})
                else:
                    self.send_json({'success': False, 'error': 'Not found'}, 404)
            else:
                self.send_json({'error': 'Not found'}, 404)
        
        except Exception as e:
            self.send_json({'success': False, 'error': str(e)}, 400)
    
    def do_PUT(self):
        """PUT - Met à jour une espèce"""
        try:
            path = urllib.parse.urlparse(self.path).path
            
            if path.startswith('/api/especes/') and path != '/api/especes/':
                espece_id = int(path.split('/')[-1])
                content_length = int(self.headers.get('Content-Length', 0))
                body = self.rfile.read(content_length).decode('utf-8')
                data = json.loads(body)
                
                conn = sqlite3.connect('database/oiseaux.db')
                c = conn.cursor()
                
                # Mapper les champs (accepter nom_commun et nom_francais)
                updates = {}
                field_map = {
                    'nom_commun': 'nom_francais',
                    'nom_francais': 'nom_francais',
                    'nom_scientifique': 'nom_scientifique',
                    'taille_cm': 'taille_cm',
                    'poids_g': 'poids_g',
                    'habitat': 'habitat',
                    'statut_conservation': 'statut',
                    'statut': 'statut',
                    'longevite_ans': 'longevite_ans',
                    'nombre_individus': 'nombre_individus'
                }
                
                for client_field, db_field in field_map.items():
                    if client_field in data and db_field not in updates:
                        updates[db_field] = data[client_field]
                
                if not updates:
                    self.send_json({'error': 'No fields to update'}, 400)
                    return
                
                # Construire la requête UPDATE
                set_clause = ', '.join([f'{k} = ?' for k in updates.keys()])
                query = f'UPDATE espece SET {set_clause} WHERE id_espece = ?'
                params = list(updates.values()) + [espece_id]
                
                c.execute(query, params)
                conn.commit()
                affected = c.rowcount
                conn.close()
                
                if affected > 0:
                    self.send_json({'success': True, 'id_espece': espece_id})
                else:
                    self.send_json({'success': False, 'error': 'Not found'}, 404)
            else:
                self.send_json({'error': 'Not found'}, 404)
        
        except Exception as e:
            self.send_json({'success': False, 'error': str(e)}, 400)
    
    def do_OPTIONS(self):
        """Gère les requêtes CORS preflight"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def send_json(self, data, status=200):
        """Envoie une réponse JSON"""
        response = json.dumps(data).encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Content-Length', len(response))
        self.end_headers()
        self.wfile.write(response)
    
    def log_message(self, format, *args):
        print(f"[{self.client_address[0]}] {format % args}")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 5000), APIHandler)
    print('API Bird Encyclopedia running on http://0.0.0.0:5000')
    print('\nAPI Endpoints:')
    print('  GET    /api/especes              - List species')
    print('  GET    /api/especes/{id}         - Get species details')
    print('  POST   /api/especes              - Create species')
    print('  PUT    /api/especes/{id}         - Update species')
    print('  DELETE /api/especes/{id}         - Delete species')
    print('  GET    /api/habitats             - List habitats')
    print('  GET    /api/health               - Health check')
    print('\nServer ready!')
    server.serve_forever()

-- ============================================================================
-- REQUÊTES SQL COMPLEXES - Encyclopédie des Oiseaux
-- ============================================================================
-- Exemples de requêtes avancées pour explorer la BD
-- À exécuter dans SQLite après l'initialisation

-- ============================================================================
-- 1. STATISTIQUES GÉNÉRALES
-- ============================================================================

-- Nombre total d'espèces, images, auteurs
SELECT 
  (SELECT COUNT(*) FROM ESPÈCE) as total_especes,
  (SELECT COUNT(*) FROM IMAGE) as total_images,
  (SELECT COUNT(*) FROM AUTEUR) as total_auteurs,
  (SELECT COUNT(*) FROM PAYS) as total_pays,
  (SELECT COUNT(DISTINCT id_espece) FROM DISTRIBUTION) as especes_distribuees;

-- Répartition des espèces par ordre taxonomique
SELECT t.ordre, COUNT(e.id_espece) as nombre_especes
FROM TAXONOMIE t
LEFT JOIN ESPÈCE e ON t.id_taxonomie = e.id_taxonomie
GROUP BY t.ordre
ORDER BY nombre_especes DESC;

-- Répartition par statut de conservation
SELECT statut_conservation, COUNT(*) as nombre_especes
FROM ESPÈCE
GROUP BY statut_conservation
ORDER BY nombre_especes DESC;

-- ============================================================================
-- 2. RECHERCHE ET FILTRAGE
-- ============================================================================

-- Espèces par gamme de taille (ex: petits oiseaux < 25cm)
SELECT nom_commun, hauteur_min, hauteur_max, poids_min, poids_max
FROM ESPÈCE
WHERE hauteur_max < 25
ORDER BY hauteur_max DESC;

-- Espèces par gamme de poids
SELECT nom_commun, poids_min, poids_max, hauteur_min, hauteur_max
FROM ESPÈCE
WHERE poids_max > 800
ORDER BY poids_max DESC;

-- Espèces par habitat
SELECT DISTINCT habitat, COUNT(*) as nombre_especes
FROM ESPÈCE
WHERE habitat IS NOT NULL
GROUP BY habitat
ORDER BY nombre_especes DESC;

-- Recherche par nom (LIKE)
SELECT id_espece, nom_commun, nom_scientifique, statut_conservation
FROM ESPÈCE
WHERE nom_commun LIKE '%corbeau%' OR nom_scientifique LIKE '%corvus%';

-- ============================================================================
-- 3. DONNÉES JOINS COMPLEXES
-- ============================================================================

-- Infos complètes avec taxonomie ET nombre d'images
SELECT 
  e.id_espece,
  e.nom_commun,
  e.nom_scientifique,
  t.ordre,
  t.famille,
  t.genre,
  ROUND(e.hauteur_min, 2) as hauteur_min_cm,
  ROUND(e.hauteur_max, 2) as hauteur_max_cm,
  ROUND(e.poids_min, 1) as poids_min_g,
  ROUND(e.poids_max, 1) as poids_max_g,
  COUNT(i.id_image) as nombre_images,
  COUNT(DISTINCT d.id_pays) as pays_distribution
FROM ESPÈCE e
JOIN TAXONOMIE t ON e.id_taxonomie = t.id_taxonomie
LEFT JOIN IMAGE i ON e.id_espece = i.id_espece
LEFT JOIN DISTRIBUTION d ON e.id_espece = d.id_espece
GROUP BY e.id_espece
ORDER BY nombre_images DESC, e.nom_commun;

-- Photos par espèce avec auteur
SELECT 
  e.nom_commun,
  COUNT(i.id_image) as nombre_photos,
  GROUP_CONCAT(DISTINCT a.nom || ' ' || a.prenom, ', ') as photographes,
  GROUP_CONCAT(DISTINCT i.localisation, '; ') as localisations
FROM ESPÈCE e
LEFT JOIN IMAGE i ON e.id_espece = i.id_espece
LEFT JOIN AUTEUR a ON i.id_auteur = a.id_auteur
GROUP BY e.id_espece
HAVING nombre_photos > 0
ORDER BY nombre_photos DESC;

-- Espèces présentes dans un pays spécifique
SELECT 
  e.nom_commun,
  t.ordre,
  d.statut_presence,
  d.date_start,
  d.date_end
FROM DISTRIBUTION d
JOIN ESPÈCE e ON d.id_espece = e.id_espece
JOIN TAXONOMIE t ON e.id_taxonomie = t.id_taxonomie
JOIN PAYS p ON d.id_pays = p.id_pays
WHERE p.nom_pays = 'France'
ORDER BY e.nom_commun;

-- Auteurs et leurs contributions (photos par auteur)
SELECT 
  a.id_auteur,
  a.nom,
  a.prenom,
  a.email,
  COUNT(i.id_image) as nombre_photos,
  COUNT(DISTINCT i.id_espece) as especes_photographiees,
  MIN(i.date_prise) as premiere_photo,
  MAX(i.date_prise) as derniere_photo
FROM AUTEUR a
LEFT JOIN IMAGE i ON a.id_auteur = i.id_auteur
GROUP BY a.id_auteur
ORDER BY nombre_photos DESC;

-- ============================================================================
-- 4. REQUÊTES FILTRÉES AVANCÉES
-- ============================================================================

-- Espèces migrantes d'Europe vers l'Afrique
SELECT DISTINCT
  e.nom_commun,
  p_depart.continent as continent_origine
FROM ESPÈCE e
JOIN DISTRIBUTION d_origine ON e.id_espece = d_origine.id_espece
JOIN PAYS p_depart ON d_origine.id_pays = p_depart.id_pays
WHERE d_origine.statut_presence = 'Migrante'
  AND p_depart.continent = 'Europe'
ORDER BY e.nom_commun;

-- Oiseaux résidents dans plusieurs continents
SELECT 
  e.nom_commun,
  COUNT(DISTINCT p.continent) as continents,
  GROUP_CONCAT(DISTINCT p.continent, ', ') as continents_list
FROM ESPÈCE e
JOIN DISTRIBUTION d ON e.id_espece = d.id_espece
JOIN PAYS p ON d.id_pays = p.id_pays
WHERE d.statut_presence = 'Résidente'
GROUP BY e.id_espece
HAVING continents > 1
ORDER BY continents DESC;

-- Espèces menacées (VU, EN, CR) par continent
SELECT 
  p.continent,
  e.nom_commun,
  e.statut_conservation,
  COUNT(i.id_image) as nombre_images
FROM ESPÈCE e
JOIN DISTRIBUTION d ON e.id_espece = d.id_espece
JOIN PAYS p ON d.id_pays = p.id_pays
LEFT JOIN IMAGE i ON e.id_espece = i.id_espece
WHERE e.statut_conservation IN ('VU', 'EN', 'CR')
GROUP BY e.id_espece, p.continent
ORDER BY p.continent, e.statut_conservation DESC;

-- ============================================================================
-- 5. AGRÉGATIONS ET STATISTIQUES AVANCÉES
-- ============================================================================

-- Taille moyenne par ordre taxonomique
SELECT 
  t.ordre,
  COUNT(e.id_espece) as nombre_especes,
  ROUND(AVG(e.hauteur_max), 2) as hauteur_moyenne_cm,
  ROUND(AVG(e.poids_max), 1) as poids_moyen_g,
  MAX(e.hauteur_max) as plus_grand_cm,
  MIN(e.hauteur_min) as plus_petit_cm
FROM TAXONOMIE t
JOIN ESPÈCE e ON t.id_taxonomie = e.id_taxonomie
GROUP BY t.id_taxonomie
ORDER BY nombre_especes DESC;

-- Espèces par couverture géographique (nombre de pays)
SELECT 
  e.nom_commun,
  COUNT(DISTINCT d.id_pays) as nombre_pays,
  GROUP_CONCAT(DISTINCT p.nom_pays, ', ') as pays,
  COUNT(DISTINCT p.continent) as continents
FROM ESPÈCE e
JOIN DISTRIBUTION d ON e.id_espece = d.id_espece
JOIN PAYS p ON d.id_pays = p.id_pays
GROUP BY e.id_espece
ORDER BY nombre_pays DESC;

-- Classement des pays avec le plus d'espèces
SELECT 
  p.nom_pays,
  p.continent,
  COUNT(DISTINCT d.id_espece) as nombre_especes,
  GROUP_CONCAT(DISTINCT e.nom_commun, ', ') as especes
FROM PAYS p
LEFT JOIN DISTRIBUTION d ON p.id_pays = d.id_pays
LEFT JOIN ESPÈCE e ON d.id_espece = e.id_espece
GROUP BY p.id_pays
ORDER BY nombre_especes DESC;

-- ============================================================================
-- 6. REQUÊTES DE VALIDATION & CONTRÔLE DE QUALITÉ
-- ============================================================================

-- Espèces sans photos
SELECT e.id_espece, e.nom_commun
FROM ESPÈCE e
LEFT JOIN IMAGE i ON e.id_espece = i.id_espece
WHERE i.id_image IS NULL;

-- Espèces sans distribution
SELECT e.id_espece, e.nom_commun
FROM ESPÈCE e
LEFT JOIN DISTRIBUTION d ON e.id_espece = d.id_espece
WHERE d.id_espece IS NULL;

-- Images orphelines (espèce supprimée mais image existante)
-- Note: Impossible avec CASCADE DELETE
SELECT * FROM IMAGE WHERE id_espece NOT IN (SELECT id_espece FROM ESPÈCE);

-- Auteurs sans photos
SELECT a.id_auteur, a.nom, a.prenom, a.email
FROM AUTEUR a
LEFT JOIN IMAGE i ON a.id_auteur = i.id_auteur
WHERE i.id_image IS NULL;

-- Doublons potentiels (même nom scientifique)
SELECT nom_scientifique, COUNT(*) as nombre
FROM ESPÈCE
GROUP BY nom_scientifique
HAVING COUNT(*) > 1;

-- ============================================================================
-- 7. REQUÊTES DE PAGINATION ET PERFORMANCE
-- ============================================================================

-- Premiers 10 oiseaux (pour pagination frontend)
SELECT id_espece, nom_commun, hauteur_max, poids_max
FROM ESPÈCE
ORDER BY nom_commun
LIMIT 10 OFFSET 0;

-- Espèces avec performance optimisée (index)
EXPLAIN QUERY PLAN
SELECT * FROM ESPÈCE WHERE statut_conservation = 'LC' ORDER BY nom_commun;

-- ============================================================================
-- 8. MISES À JOUR ET MAINTENANCE
-- ============================================================================

-- Exemple: Mettre à jour la date de modification
UPDATE ESPÈCE 
SET date_modification = CURRENT_TIMESTAMP 
WHERE id_espece = 1;

-- Exemple: Ajouter une nouvelle espèce
INSERT INTO ESPÈCE 
(nom_commun, nom_scientifique, description, hauteur_min, hauteur_max, 
 poids_min, poids_max, envergure, habitat, statut_conservation, id_taxonomie)
VALUES 
('Chouette effraie', 'Tyto alba', 'Magnifique chouette blanche de nuit', 
 33, 39, 400, 700, 85, 'Forêts et zones urbaines', 'LC',
 (SELECT id_taxonomie FROM TAXONOMIE WHERE ordre='Strigiformes' LIMIT 1));

-- Exemple: Ajouter une distribution
INSERT INTO DISTRIBUTION (id_espece, id_pays, statut_presence)
VALUES (1, 1, 'Résidente');

-- Exemple: Supprimer une espèce (CASCADE delete les images)
-- DELETE FROM ESPÈCE WHERE id_espece = 999;

-- ============================================================================
-- FIN DES REQUÊTES
-- ============================================================================

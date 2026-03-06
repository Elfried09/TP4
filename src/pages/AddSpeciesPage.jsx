// Page : Ajouter une espèce
import React, { useState, useEffect } from 'react';

export default function AddSpeciesPage() {
 const [formData, setFormData] = useState({
 nom_commun: '',
 nom_scientifique: '',
 description: '',
 hauteur_min: '',
 hauteur_max: '',
 poids_min: '',
 poids_max: '',
 envergure: '',
 habitat: '',
 statut_conservation: 'LC',
 id_taxonomie: ''
 });

 const [taxonomies, setTaxonomies] = useState([]);
 const [loading, setLoading] = useState(true);
 const [message, setMessage] = useState(null);
 const [messageType, setMessageType] = useState('');

 useEffect(() => {
 // Récupérer les taxonomies pour le formulaire
 fetch('http://localhost:5000/api/taxonomies')
 .then(r => r.json())
 .then(data => {
 if (data.success) {
 setTaxonomies(data.data);
 }
 setLoading(false);
 })
 .catch(err => {
 console.error('Erreur:', err);
 setLoading(false);
 });
 }, []);

 const handleChange = (e) => {
 const { name, value } = e.target;
 setFormData(prev => ({
 ...prev,
 [name]: value === '' ? '' : (
 ['hauteur_min', 'hauteur_max', 'poids_min', 'poids_max', 'envergure', 'id_taxonomie'].includes(name) 
 ? parseInt(value) || ''
 : value
 )
 }));
 };

 const handleSubmit = async (e) => {
 e.preventDefault();

 if (!formData.nom_commun || !formData.nom_scientifique || !formData.id_taxonomie) {
 setMessage('Veuillez remplir todos les champs obligatoires');
 setMessageType('danger');
 return;
 }

 try {
 const response = await fetch('http://localhost:5000/api/especes', {
 method: 'POST',
 headers: { 'Content-Type': 'application/json' },
 body: JSON.stringify(formData)
 });

 const data = await response.json();

 if (data.success) {
 setMessage(` Espèce créée avec succès! (ID: ${data.id_espece})`);
 setMessageType('success');
 // Réinitialiser le formulaire
 setFormData({
 nom_commun: '',
 nom_scientifique: '',
 description: '',
 hauteur_min: '',
 hauteur_max: '',
 poids_min: '',
 poids_max: '',
 envergure: '',
 habitat: '',
 statut_conservation: 'LC',
 id_taxonomie: ''
 });
 } else {
 setMessage(` ${data.error}`);
 setMessageType('danger');
 }
 } catch (err) {
 setMessage(` Erreur: ${err.message}`);
 setMessageType('danger');
 }
 };

 if (loading) {
 return <div className="loading"><div className="spinner"></div>Chargement...</div>;
 }

 return (
 <div className="container">
 <h2>Ajouter une nouvelle espèce</h2>

 {message && (
 <div className={`alert alert-${messageType}`}>
 {message}
 </div>
 )}

 <form onSubmit={handleSubmit}>
 <div className="form-group">
 <label htmlFor="nom_commun">Nom commun </label>
 <input
 id="nom_commun"
 type="text"
 name="nom_commun"
 value={formData.nom_commun}
 onChange={handleChange}
 placeholder="Ex: Pie bavarde"
 required
 />
 </div>

 <div className="form-group">
 <label htmlFor="nom_scientifique">Nom scientifique </label>
 <input
 id="nom_scientifique"
 type="text"
 name="nom_scientifique"
 value={formData.nom_scientifique}
 onChange={handleChange}
 placeholder="Ex: Pica pica"
 required
 />
 </div>

 <div className="form-group">
 <label htmlFor="id_taxonomie">Taxonomie </label>
 <select
 id="id_taxonomie"
 name="id_taxonomie"
 value={formData.id_taxonomie}
 onChange={handleChange}
 required
 >
 <option value="">Sélectionner une taxonomie</option>
 {taxonomies.map(tax => (
 <option key={tax.id_taxonomie} value={tax.id_taxonomie}>
 {tax.ordre} / {tax.famille} / {tax.genre}
 </option>
 ))}
 </select>
 </div>

 <div className="form-group">
 <label htmlFor="description">Description</label>
 <textarea
 id="description"
 name="description"
 value={formData.description}
 onChange={handleChange}
 placeholder="Description de l'espèce..."
 ></textarea>
 </div>

 <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
 <div className="form-group">
 <label htmlFor="hauteur_min">Hauteur min (cm)</label>
 <input
 id="hauteur_min"
 type="number"
 name="hauteur_min"
 value={formData.hauteur_min}
 onChange={handleChange}
 />
 </div>

 <div className="form-group">
 <label htmlFor="hauteur_max">Hauteur max (cm)</label>
 <input
 id="hauteur_max"
 type="number"
 name="hauteur_max"
 value={formData.hauteur_max}
 onChange={handleChange}
 />
 </div>

 <div className="form-group">
 <label htmlFor="poids_min">Poids min (g)</label>
 <input
 id="poids_min"
 type="number"
 name="poids_min"
 value={formData.poids_min}
 onChange={handleChange}
 />
 </div>

 <div className="form-group">
 <label htmlFor="poids_max">Poids max (g)</label>
 <input
 id="poids_max"
 type="number"
 name="poids_max"
 value={formData.poids_max}
 onChange={handleChange}
 />
 </div>

 <div className="form-group">
 <label htmlFor="envergure">Envergure (cm)</label>
 <input
 id="envergure"
 type="number"
 name="envergure"
 value={formData.envergure}
 onChange={handleChange}
 />
 </div>

 <div className="form-group">
 <label htmlFor="statut_conservation">Statut conservation</label>
 <select
 id="statut_conservation"
 name="statut_conservation"
 value={formData.statut_conservation}
 onChange={handleChange}
 >
 <option value="LC">LC - Non menacé</option>
 <option value="NT">NT - Proche du menacé</option>
 <option value="VU">VU - Vulnérable</option>
 <option value="EN">EN - Menacé</option>
 <option value="CR">CR - En danger critique</option>
 </select>
 </div>
 </div>

 <div className="form-group">
 <label htmlFor="habitat">Habitat</label>
 <input
 id="habitat"
 type="text"
 name="habitat"
 value={formData.habitat}
 onChange={handleChange}
 placeholder="Ex: Forêt mixte, Zones urbaines"
 />
 </div>

 <button type="submit">Créer l'espèce</button>
 </form>
 </div>
 );
}

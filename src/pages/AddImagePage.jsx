// Page : Ajouter une image pour une espèce
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

export default function AddImagePage() {
 const { id } = useParams();
 const navigate = useNavigate();

 const [speciesName, setSpeciesName] = useState('');
 const [file, setFile] = useState(null);
 const [loading, setLoading] = useState(true);
 const [submitting, setSubmitting] = useState(false);
 const [message, setMessage] = useState(null);
 const [messageType, setMessageType] = useState('');
 const [formData, setFormData] = useState({
 id_auteur: '',
 description_image: '',
 localisation: ''
 });

 useEffect(() => {
 // Récupérer le nom de l'espèce
 if (id) {
 fetch(`http://localhost:5000/api/especes/${id}`)
 .then(r => r.json())
 .then(data => {
 if (data.success) {
 setSpeciesName(data.data.nom_commun);
 }
 setLoading(false);
 })
 .catch(err => {
 console.error('Erreur:', err);
 setLoading(false);
 });
 }
 }, [id]);

 const handleChange = (e) => {
 const { name, value } = e.target;
 setFormData(prev => ({
 ...prev,
 [name]: value
 }));
 };

 const handleFileChange = (e) => {
 const selectedFile = e.target.files[0];
 if (selectedFile) {
 const validTypes = ['image/png', 'image/jpeg', 'image/gif'];
 if (validTypes.includes(selectedFile.type)) {
 setFile(selectedFile);
 setMessage(null);
 } else {
 setMessage('Format non autorisé (PNG, JPG, GIF uniquement)');
 setMessageType('warning');
 }
 }
 };

 const handleSubmit = async (e) => {
 e.preventDefault();

 if (!file) {
 setMessage('Veuillez sélectionner une image');
 setMessageType('warning');
 return;
 }

 setSubmitting(true);

 const formDataToSend = new FormData();
 formDataToSend.append('image', file);
 formDataToSend.append('id_auteur', formData.id_auteur);
 formDataToSend.append('description_image', formData.description_image);
 formDataToSend.append('localisation', formData.localisation);

 try {
 const response = await fetch(
 `http://localhost:5000/api/especes/${id}/images`,
 {
 method: 'POST',
 body: formDataToSend
 }
 );

 const data = await response.json();

 if (data.success) {
 setMessage(` Image ajoutée avec succès!`);
 setMessageType('success');
 setTimeout(() => {
 navigate(`/species/${id}`);
 }, );
 } else {
 setMessage(` ${data.error}`);
 setMessageType('danger');
 }
 } catch (err) {
 setMessage(` Erreur: ${err.message}`);
 setMessageType('danger');
 } finally {
 setSubmitting(false);
 }
 };

 if (loading) {
 return <div className="loading"><div className="spinner"></div>Chargement...</div>;
 }

 return (
 <div className="container">
 <h2>Ajouter une image pour <strong>{speciesName}</strong></h2>

 {message && (
 <div className={`alert alert-${messageType}`}>
 {message}
 </div>
 )}

 <form onSubmit={handleSubmit}>
 <div className="form-group">
 <label htmlFor="image">Image </label>
 <input
 id="image"
 type="file"
 onChange={handleFileChange}
 accept="image/"
 required
 />
 <small style={{ display: 'block', marginTop: '15px', color: '#666' }}>
 Formats acceptés: PNG, JPG, GIF (Max MB)
 </small>
 {file && (
 <div style={{
 marginTop: '15px',
 padding: '15px',
 backgroundColor: 'fff',
 borderRadius: '8px',
 fontSize: '14px'
 }}>
 Fichier sélectionné: {file.name}
 </div>
 )}
 </div>

 <div className="form-group">
 <label htmlFor="description_image">Description de l'image</label>
 <textarea
 id="description_image"
 name="description_image"
 value={formData.description_image}
 onChange={handleChange}
 placeholder="Décrivez ce qui se passe sur la photo..."
 ></textarea>
 </div>

 <div className="form-group">
 <label htmlFor="localisation">Localisation (lieu de prise)</label>
 <input
 id="localisation"
 type="text"
 name="localisation"
 value={formData.localisation}
 onChange={handleChange}
 placeholder="Ex: Forêt de Fontainebleau"
 />
 </div>

 <div className="form-group">
 <label htmlFor="id_auteur">Auteur</label>
 <select
 id="id_auteur"
 name="id_auteur"
 value={formData.id_auteur}
 onChange={handleChange}
 >
 <option value="">Marc Dupont</option>
 <option value="">Sophie Martin</option>
 <option value="">Jean Blanc</option>
 <option value="">Alice Petite</option>
 <option value="">Michel Durand</option>
 </select>
 </div>

 <button type="submit" disabled={submitting}>
 {submitting ? 'Envoi en cours...' : 'Ajouter l\'image'}
 </button>
 </form>
 </div>
 );
}

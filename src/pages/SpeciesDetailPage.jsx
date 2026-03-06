// Page : Détail d'une espèce
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

export default function SpeciesDetailPage() {
 const { id } = useParams();
 const navigate = useNavigate();
 const [species, setSpecies] = useState(null);
 const [images, setImages] = useState([]);
 const [loading, setLoading] = useState(true);

 useEffect(() => {
 fetchSpecies();
 fetchImages();
 }, [id]);

 const fetchSpecies = async () => {
 setLoading(true);
 try {
 const response = await fetch(`http://localhost:5000/api/especes/${id}`);
 const data = await response.json();
 if (data.success) {
 setSpecies(data.data);
 }
 } catch (err) {
 console.error('Erreur:', err);
 } finally {
 setLoading(false);
 }
 };

 const fetchImages = async () => {
 try {
 const response = await fetch(`http://localhost:5000/api/especes/${id}/images`);
 const data = await response.json();
 if (data.success && data.images) {
 setImages(data.images);
 }
 } catch (err) {
 console.error('Erreur images:', err);
 }
 };

 const handleDelete = async () => {
 if (!window.confirm('Êtes-vous sûr de vouloir supprimer cette espèce?')) return;

 try {
 const response = await fetch(`http://localhost:5000/api/especes/${id}`, {
 method: 'DELETE'
 });
 const data = await response.json();

 if (data.success) {
 alert('Espèce supprimée');
 navigate('/species');
 }
 } catch (err) {
 alert('Erreur: ' + err.message);
 }
 };

 if (loading) {
 return <div className="loading"><div className="spinner"></div>Chargement...</div>;
 }

 if (!species) {
 return (
 <div className="container">
 <div className="alert alert-danger">Espèce non trouvée</div>
 </div>
 );
 }

 return (
 <div className="container">
 <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
 <h1>{species.nom_commun}</h1>
 <div style={{ display: 'flex', gap: '10px' }}>
 <button onClick={() => navigate(`/add-image/${id}`)} className="btn btn-primary">
 Ajouter une image
 </button>
 <button onClick={handleDelete} className="btn btn-danger">
 Supprimer
 </button>
 </div>
 </div>

 <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px', marginBottom: '15px' }}>
 {/* Infos générales */}
 <div className="card">
 <h3 className="card-title">Informations générales</h3>
 <p><strong>Nom scientifique:</strong> <em>{species.nom_scientifique}</em></p>
 <p><strong>Description:</strong> {species.description || 'N/A'}</p>

 <h3 style={{ marginTop: '15px', marginBottom: '10px' }}>Taxonomie</h3>
 <p><strong>Ordre:</strong> {species.ordre}</p>
 <p><strong>Famille:</strong> {species.famille}</p>
 <p><strong>Genre:</strong> {species.genre}</p>

 <h3 style={{ marginTop: '15px', marginBottom: '10px' }}>
Caractéristiques physiques</h3>
 <p><strong>Hauteur:</strong> {species.hauteur_min || '?'} - {species.hauteur_max || '?'} cm</p>
 <p><strong>Poids:</strong> {species.poids_min || '?'} - {species.poids_max || '?'} g</p>
 <p><strong>Envergure:</strong> {species.envergure || '?'} cm</p>

 <h3 style={{ marginTop: '15px', marginBottom: '10px' }}>Habitat et conservation</h3>
 <p><strong>Habitat:</strong> {species.habitat || 'N/A'}</p>
 <p>
 <strong>Statut de conservation:</strong>
 <span className={`badge badge-${
 species.statut_conservation === 'LC' ? 'success' : 'danger'
 }`} style={{ marginLeft: '10px' }}>
 {species.statut_conservation}
 </span>
 </p>
 </div>

 {/* Distribution */}
 <div className="card">
 <h3 className="card-title">Distribution géographique</h3>
 {species.distribution ? (
 <p style={{ lineHeight: '1.6', fontSize: '15px' }}>
 {species.distribution}
 </p>
 ) : (
 <p style={{ color: '#666' }}>Pas de données de distribution</p>
 )}
 </div>
 </div>

 {/* Images */}
 <div className="card">
 <h3 className="card-title">Photos ({images.length})</h3>
 {images && images.length > 0 ? (
 <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '15px' }}>
 {images.map(img => (
 <div key={img.id_image} style={{
 border: '1px solid #ddd',
 borderRadius: '8px',
 overflow: 'hidden',
 backgroundColor: '#fff',
 }}>
 <img src={img.url} alt={img.titre} style={{
 width: '100%',
 height: '200px',
 objectFit: 'cover'
 }} />
 <div style={{ padding: '10px' }}>
 <p><strong>{img.titre}</strong></p>
 {img.description && (
 <p style={{ fontSize: '14px', color: '#666', margin: '5px 0 0 0' }}>{img.description}</p>
 )}
 </div>
 </div>
 ))}
 </div>
 ) : (
 <p style={{ color: '#666' }}>Pas d'images pour cette espèce</p>
 )}
 </div>

 <button onClick={() => navigate('/species')} className="btn btn-secondary" style={{ marginTop: '15px' }}>
 ← Retour à la liste
 </button>
 </div>
 );
}

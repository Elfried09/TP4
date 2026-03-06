// Page : Liste tous les oiseaux
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

export default function SpeciesListPage() {
 const [species, setSpecies] = useState([]);
 const [loading, setLoading] = useState(true);
 const [page, setPage] = useState(1);
 const [total, setTotal] = useState();
 const limit = 12;

 useEffect(() => {
 fetchSpecies();
 }, [page]);

 const fetchSpecies = async () => {
 setLoading(true);
 try {
 const offset = (page - 1) * limit;
 const response = await fetch(
 `http://localhost:5000/api/especes?limit=${limit}&offset=${offset}&sort=nom_commun`
 );
 const data = await response.json();
 if (data.success) {
 setSpecies(data.data);
 setTotal(data.total);
 }
 } catch (err) {
 console.error('Erreur:', err);
 } finally {
 setLoading(false);
 }
 };

 const totalPages = Math.ceil(total / limit);

 if (loading) {
 return <div className="loading"><div className="spinner"></div>Chargement...</div>;
 }

 return (
 <div className="container">
 <h2>Tous les oiseaux</h2>
 <p style={{ marginBottom: '15px', color: '#666' }}>
 Total: <strong>{total}</strong> espèces
 </p>

 <div className="grid">
 {species.map(specie => (
 <div key={specie.id_espece} className="card">
 <h2 className="card-title">{specie.nom_commun}</h2>
 <p className="card-subtitle" style={{ fontStyle: 'italic' }}>
 {specie.nom_scientifique}
 </p>
 <div style={{ marginBottom: '15px' }}>
 <p><strong>Habitat:</strong> {specie.habitat}</p>
 <p>
 <strong>Statut:</strong> 
 <span className={`badge badge-${
 specie.statut_conservation === 'LC' ? 'success' : 'danger'
 }`} style={{ marginLeft: '10px' }}>
 {specie.statut_conservation}
 </span>
 </p>
 {specie.description && (
 <p style={{ fontSize: '14px', color: '#666', marginTop: '10px', marginBottom: '0' }}>
 {specie.description}
 </p>
 )}
 </div>
 <p style={{ fontSize: '14px', color: '#999', marginBottom: '15px', marginTop: '10px' }}>
 📸 {specie.nombre_images} image{specie.nombre_images !== 1 ? 's' : ''}
 </p>
 <Link to={`/species/${specie.id_espece}`} className="btn btn-primary">
 Voir détails →
 </Link>
 </div>
 ))}
 </div>

 {/* Pagination */}
 <div className="pagination">
 {page > 1 && (
 <button onClick={() => setPage(page - 1)}>← Précédent</button>
 )}
 {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
 <button
 key={p}
 onClick={() => setPage(p)}
 className={page === p ? 'active' : ''}
 >
 {p}
 </button>
 ))}
 {page < totalPages && (
 <button onClick={() => setPage(page + 1)}>Suivant →</button>
 )}
 </div>
 </div>
 );
}

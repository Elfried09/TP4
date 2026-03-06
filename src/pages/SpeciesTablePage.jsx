// Page : Tableau avec filtres et tri
import React, { useState, useEffect } from 'react';

export default function SpeciesTablePage() {
 const [species, setSpecies] = useState([]);
 const [loading, setLoading] = useState(true);
 const [sortBy, setSortBy] = useState('nom_commun');
 const [sortOrder, setSortOrder] = useState('asc');
 const [habitat, setHabitat] = useState('');
 const [habitats, setHabitats] = useState([]);

 useEffect(() => {
 fetchHabitats();
 }, []);

 useEffect(() => {
 fetchSpecies();
 }, [sortBy, sortOrder, habitat]);

 const fetchHabitats = async () => {
 try {
 const response = await fetch('http://localhost:5000/api/habitats');
 const data = await response.json();
 if (data.success) {
 setHabitats(data.habitats);
 }
 } catch (err) {
 console.error('Erreur habitats:', err);
 }
 };

 const fetchSpecies = async () => {
 setLoading(true);
 try {
 let url = `http://localhost:5000/api/especes?limit=100&sort=${sortBy}&order=${sortOrder}`;
 if (habitat) {
 url += `&habitat=${encodeURIComponent(habitat)}`;
 }

 const response = await fetch(url);
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

 const toggleSort = (column) => {
 if (sortBy === column) {
 setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
 } else {
 setSortBy(column);
 setSortOrder('asc');
 }
 };

 const SortIcon = ({ column }) => {
 if (sortBy !== column) return '↕';
 return sortOrder === 'asc' ? '↑' : '↓';
 };

 if (loading) {
 return <div className="loading"><div className="spinner"></div>Chargement...</div>;
 }

 return (
 <div className="container">
 <h2>Tableau comparatif des oiseaux</h2>

 {/* Filtres */}
 <div className="filters">
 <div className="filter-group">
 <div className="filter-item">
 <label htmlFor="habitat">Filtrer par habitat</label>
 <select
 id="habitat"
 value={habitat}
 onChange={(e) => setHabitat(e.target.value)}
 >
 <option value="">Tous les habitats</option>
 {habitats.map((hab, idx) => (
 <option key={idx} value={hab}>{hab}</option>
 ))}
 </select>
 </div>
 <div style={{ flex: 1, textAlign: 'right', paddingBottom: '10px' }}>
 <small style={{ color: '#666' }}>{species.length} oiseaux affichés</small>
 </div>
 </div>
 </div>

 {/* Tableau */}
 <table>
 <thead>
 <tr>
 <th onClick={() => toggleSort('nom_commun')} style={{ cursor: 'pointer' }}>
 Espèce<SortIcon column="nom_commun" />
 </th>
 <th>Nom scientifique</th>
 <th onClick={() => toggleSort('taille_cm')} style={{ cursor: 'pointer' }}>
 Taille cm<SortIcon column="taille_cm" />
 </th>
 <th onClick={() => toggleSort('poids_g')} style={{ cursor: 'pointer' }}>
 Poids g<SortIcon column="poids_g" />
 </th>
 <th onClick={() => toggleSort('longevite_ans')} style={{ cursor: 'pointer' }}>
 Longevite<SortIcon column="longevite_ans" />
 </th>
 <th onClick={() => toggleSort('nombre_individus')} style={{ cursor: 'pointer' }}>
 Population<SortIcon column="nombre_individus" />
 </th>
 <th>Habitat</th>
 <th>Statut</th>
 <th>Images</th>
 </tr>
 </thead>
 <tbody>
 {species.map(specie => {
 const tooltipText = [
 specie.nom_commun,
 specie.description || '',
 specie.distribution || ''
 ].filter(Boolean).join('\n\n');
 
 return (
 <tr key={specie.id_espece} title={tooltipText}>
 <td><strong>{specie.nom_commun}</strong></td>
 <td style={{ fontStyle: 'italic', fontSize: '14px' }}>
 {specie.nom_scientifique}
 </td>
 <td>{specie.taille_cm || '?'}</td>
 <td>{specie.poids_g || '?'}</td>
 <td>{specie.longevite_ans || '?'}</td>
 <td>{specie.nombre_individus ? specie.nombre_individus.toLocaleString('fr-FR') : '?'}</td>
 <td style={{ fontSize: '14px' }}>{specie.habitat || 'N/A'}</td>
 <td>
 <span className={`badge badge-${
 specie.statut_conservation === 'LC' ? 'success' : 'danger'
 }`}>
 {specie.statut_conservation}
 </span>
 </td>
 <td style={{ textAlign: 'center' }}>{specie.nombre_images}</td>
 </tr>
 );
 })}
 </tbody>
 </table>

 {species.length === 0 && (
 <div style={{ padding: '15px', textAlign: 'center', color: '#666' }}>
 Aucune espèce ne correspond aux critères sélectionnés
 </div>
 )}
 </div>
 );
}

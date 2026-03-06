// App.jsx - Composant principal avec routing
import React from 'react';
import { BrowserRouter, Routes, Route, Link, useLocation } from 'react-router-dom';
import './styles/global.css';

// Pages
import AddSpeciesPage from './pages/AddSpeciesPage';
import SpeciesListPage from './pages/SpeciesListPage';
import SpeciesDetailPage from './pages/SpeciesDetailPage';
import SpeciesTablePage from './pages/SpeciesTablePage';
import AddImagePage from './pages/AddImagePage';

// Composant Navigation
function Navigation() {
 const location = useLocation();

 const isActive = (path) => location.pathname === path || location.pathname.startsWith(path + '/');

 return (
 <nav>
 <ul>
 <li>
 <Link 
 to="/" 
 className={isActive('/') && location.pathname === '/' ? 'active' : ''}
 >
 Accueil
 </Link>
 </li>
 <li>
 <Link 
 to="/add-species"
 className={isActive('/add-species') ? 'active' : ''}
 >
 Ajouter espèce
 </Link>
 </li>
 <li>
 <Link 
 to="/species"
 className={isActive('/species') && location.pathname === '/species' ? 'active' : ''}
 >
 Liste oiseaux
 </Link>
 </li>
 <li>
 <Link 
 to="/table"
 className={isActive('/table') ? 'active' : ''}
 >
 Tableau comparatif
 </Link>
 </li>
 </ul>
 </nav>
 );
}

// Composant Header
function Header() {
 return (
 <header>
 <div className="container">
 <h1>Encyclopédie des Oiseaux du Monde</h1>
 <p>Découvrez et explorez la diversité des espèces d'oiseaux</p>
 </div>
 </header>
 );
}

// Composant Footer
function Footer() {
 return (
 <footer>
 <p>&copy; Encyclopédie des Oiseaux - TP - Tous droits réservés</p>
 </footer>
 );
}

// Page d'accueil
function HomePage() {
 return (
 <div className="container">
 <div style={{ maxWidth: '800px', margin: '0 auto' }}>
 <h2>Bienvenue dans l'Encyclopédie des Oiseaux!</h2>
 
 <div style={{ margin: '20px 0' }}>
 <p style={{ fontSize: '16px', lineHeight: '1.6' }}>
 Cette application vous permet d'explorer et de gérer une base de données complète sur les oiseaux du monde.
 Vous pouvez visualiser les informations détaillées sur chaque espèce, ajouter de nouvelles espèces, et
 consulter les données de distribution géographique.
 </p>
 </div>

 <div className="grid">
 <div className="card">
 <h2 className="card-title">Ajouter une espèce</h2>
 <p>Créez une nouvelle fiche espèce avec tous les détails (taxonomie, morphologie, habitat).</p>
 <Link to="/add-species" className="btn btn-primary">Commencer</Link>
 </div>

 <div className="card">
 <h2 className="card-title">Parcourir les espèces</h2>
 <p>Consultez la liste complète des oiseaux avec pagination et information détaillée.</p>
 <Link to="/species" className="btn btn-primary">Voir la liste</Link>
 </div>

 <div className="card">
 <h2 className="card-title">Tableau comparatif</h2>
 <p>Comparez jusqu'à 20 oiseaux avec tri et filtres par taille, poids et habitat.</p>
 <Link to="/table" className="btn btn-primary">Voir le tableau</Link>
 </div>
 </div>


 </div>
 </div>
 );
}

// Composant principal App
export default function App() {
 return (
 <BrowserRouter>
 <div style={{ display: 'flex', flexDirection: 'column', minHeight: 'vh' }}>
 <Header />
 <Navigation />
 
 <main style={{ flex: 1, paddingBottom: '20px' }}>
 <Routes>
 <Route path="/" element={<HomePage />} />
 <Route path="/add-species" element={<AddSpeciesPage />} />
 <Route path="/species" element={<SpeciesListPage />} />
 <Route path="/species/:id" element={<SpeciesDetailPage />} />
 <Route path="/table" element={<SpeciesTablePage />} />
 <Route path="/add-image/:id" element={<AddImagePage />} />
 
 {/* 404 route */}
 <Route path="*" element={
 <div className="container">
 <div style={{
 backgroundColor: '#fffcd5',
 padding: '40px',
 borderRadius: '8px',
 textAlign: 'center',
 marginTop: '40px'
 }}>
 <h1>404 - Page non trouvée</h1>
 <p>La page que vous recherchez n'existe pas.</p>
 <Link to="/" className="btn btn-primary">Retour à l'accueil</Link>
 </div>
 </div>
 } />
 </Routes>
 </main>

 <Footer />
 </div>
 </BrowserRouter>
 );
}

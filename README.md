# Encyclopédie des Oiseaux - TP4

Application web complète pour consulter et filtrer une base de données d'oiseaux avec API REST et interface React.

## Architecture

```
TP4/
├── src/                  # Code React
│   ├── pages/           # Pages (TablePage, ListPage, DetailPage)
│   ├── components/      # Composants réutilisables
│   ├── styles/          # Fichiers CSS
│   ├── App.jsx          # Composant principal
│   └── main.jsx         # Point d'entrée
├── database/            # Base de données SQLite
│   └── oiseaux.db       # BD avec 24 espèces
├── api_http.py          # API REST (Python HTTPServer)
├── index.html           # HTML template
├── package.json         # Dépendances npm
├── vite.config.js       # Configuration Vite
└── package-lock.json    # Versions npm verrouillées
```

## Installation

```bash
# Installer les dépendances npm
npm install
```

## Lancer l'application

### 1. Démarrer le serveur API (port 5000)
```bash
python api_http.py
```

### 2. Démarrer le serveur React (port 5177)
```bash
npm run dev
```

Ouvrez ensuite: **http://localhost:5177**

## Endpoints API

- `GET /api/especes` - Récupère toutes les espèces (avec pagination et filtres)
- `GET /api/especes/{id}` - Récupère les détails d'une espèce
- `GET /api/habitats` - Récupère tous les habitats distincts
- `GET /api/health` - Vérification de santé de l'API

## Fonctionnalités

-  Tableau comparatif avec trinage et filtrage par habitat
-  Liste paginée d'espèces
-  Détails complets de chaque oiseau
-  Classification (Ordre, Famille, Genre)
-  Taille et poids avec plages min/max
-  Habitats et statut de conservation

## Base de données

- **24 espèces d'oiseaux**
- **8 ordres**, **11 familles**, **18 genres**
- Champs: nom français/scientifique, taille, poids, habitat, statut

## Technos

- **Frontend**: React 18+, Vite 5+, React Router
- **Backend**: Python HTTPServer
- **BD**: SQLite3

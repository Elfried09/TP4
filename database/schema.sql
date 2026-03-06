-- ============================================================================
-- SCHÉMA BASE DE DONNÉES : ENCYCLOPÉDIE DES OISEAUX
-- SGBD : SQLite
-- ============================================================================

-- Suppression des tables existantes (pour réinitialisation)
DROP TABLE IF EXISTS DISTRIBUTION;
DROP TABLE IF EXISTS IMAGE;
DROP TABLE IF EXISTS ESPÈCE;
DROP TABLE IF EXISTS TAXONOMIE;
DROP TABLE IF EXISTS AUTEUR;
DROP TABLE IF EXISTS PAYS;

-- ============================================================================
-- TABLE 1 : TAXONOMIE
-- ============================================================================
CREATE TABLE TAXONOMIE (
    id_taxonomie INTEGER PRIMARY KEY AUTOINCREMENT,
    ordre VARCHAR(50) NOT NULL,
    famille VARCHAR(50) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    UNIQUE(ordre, famille, genre)
);

CREATE INDEX idx_taxonomie_ordre ON TAXONOMIE(ordre);
CREATE INDEX idx_taxonomie_famille ON TAXONOMIE(famille);

-- ============================================================================
-- TABLE 2 : ESPÈCE
-- ============================================================================
CREATE TABLE ESPÈCE (
    id_espece INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_commun VARCHAR(100) NOT NULL,
    nom_scientifique VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    hauteur_min FLOAT CHECK(hauteur_min > 0),
    hauteur_max FLOAT CHECK(hauteur_max > 0),
    poids_min FLOAT CHECK(poids_min > 0),
    poids_max FLOAT CHECK(poids_max > 0),
    envergure FLOAT CHECK(envergure > 0),
    longevite_ans INTEGER,
    nombre_individus INTEGER,
    habitat VARCHAR(200),
    statut_conservation VARCHAR(50) DEFAULT 'LC'
        CHECK(statut_conservation IN ('LC', 'NT', 'VU', 'EN', 'CR', 'EW', 'EX')),
    id_taxonomie INTEGER NOT NULL REFERENCES TAXONOMIE(id_taxonomie) ON DELETE RESTRICT,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_espece_nom_commun ON ESPÈCE(nom_commun);
CREATE INDEX idx_espece_id_taxonomie ON ESPÈCE(id_taxonomie);
CREATE INDEX idx_espece_statut ON ESPÈCE(statut_conservation);

-- ============================================================================
-- TABLE 3 : AUTEUR
-- ============================================================================
CREATE TABLE AUTEUR (
    id_auteur INTEGER PRIMARY KEY AUTOINCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    bio TEXT,
    site_web VARCHAR(200),
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auteur_email ON AUTEUR(email);
CREATE INDEX idx_auteur_nom ON AUTEUR(nom, prenom);

-- ============================================================================
-- TABLE 4 : IMAGE
-- ============================================================================
CREATE TABLE IMAGE (
    id_image INTEGER PRIMARY KEY AUTOINCREMENT,
    id_espece INTEGER NOT NULL REFERENCES ESPÈCE(id_espece) ON DELETE CASCADE,
    id_auteur INTEGER NOT NULL REFERENCES AUTEUR(id_auteur) ON DELETE CASCADE,
    url_image VARCHAR(500) NOT NULL,
    description_image TEXT,
    date_prise DATE,
    localisation VARCHAR(200),
    type_image VARCHAR(50),
    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_image_id_espece ON IMAGE(id_espece);
CREATE INDEX idx_image_id_auteur ON IMAGE(id_auteur);
CREATE INDEX idx_image_date_prise ON IMAGE(date_prise);

-- ============================================================================
-- TABLE 5 : PAYS
-- ============================================================================
CREATE TABLE PAYS (
    id_pays INTEGER PRIMARY KEY AUTOINCREMENT,
    code_iso VARCHAR(3) UNIQUE NOT NULL,
    nom_pays VARCHAR(100) NOT NULL,
    continent VARCHAR(50) NOT NULL
        CHECK(continent IN ('Afrique', 'Antarctique', 'Asie', 'Europe', 
                            'Amérique du Nord', 'Amérique Centrale', 'Amérique du Sud', 'Océanie')),
    population_initiale INTEGER
);

CREATE INDEX idx_pays_code_iso ON PAYS(code_iso);
CREATE INDEX idx_pays_continent ON PAYS(continent);

-- ============================================================================
-- TABLE 6 : DISTRIBUTION (Association N-à-N)
-- ============================================================================
CREATE TABLE DISTRIBUTION (
    id_espece INTEGER NOT NULL REFERENCES ESPÈCE(id_espece) ON DELETE CASCADE,
    id_pays INTEGER NOT NULL REFERENCES PAYS(id_pays) ON DELETE CASCADE,
    statut_presence VARCHAR(50) DEFAULT 'Résidente'
        CHECK(statut_presence IN ('Résidente', 'Migrante', 'Accidentelle', 'Hivernante')),
    date_start DATE,
    date_end DATE,
    PRIMARY KEY (id_espece, id_pays)
);

CREATE INDEX idx_distribution_pays ON DISTRIBUTION(id_pays);
CREATE INDEX idx_distribution_statut ON DISTRIBUTION(statut_presence);

-- ============================================================================
-- VUES UTILES (optionnelles)
-- ============================================================================

-- Vue pour obtenir les infos complètes d'une espèce
CREATE VIEW VUE_ESPECES_COMPLETES AS
SELECT 
    e.id_espece,
    e.nom_commun,
    e.nom_scientifique,
    e.description,
    ROUND(e.hauteur_min, 2) as hauteur_min_cm,
    ROUND(e.hauteur_max, 2) as hauteur_max_cm,
    ROUND(e.poids_min, 1) as poids_min_g,
    ROUND(e.poids_max, 1) as poids_max_g,
    ROUND(e.envergure, 2) as envergure_cm,
    e.habitat,
    e.statut_conservation,
    t.ordre,
    t.famille,
    t.genre,
    e.date_creation,
    e.date_modification
FROM ESPÈCE e
JOIN TAXONOMIE t ON e.id_taxonomie = t.id_taxonomie
ORDER BY e.nom_commun;

-- Vue pour compter les images par espèce
CREATE VIEW VUE_IMAGES_PAR_ESPECE AS
SELECT 
    e.id_espece,
    e.nom_commun,
    COUNT(i.id_image) as nombre_images,
    GROUP_CONCAT(DISTINCT a.nom || ' ' || a.prenom) as auteurs
FROM ESPÈCE e
LEFT JOIN IMAGE i ON e.id_espece = i.id_espece
LEFT JOIN AUTEUR a ON i.id_auteur = a.id_auteur
GROUP BY e.id_espece
ORDER BY nombre_images DESC;

-- Vue pour la distribution des espèces
CREATE VIEW VUE_DISTRIBUTION AS
SELECT 
    e.nom_commun,
    p.nom_pays,
    p.continent,
    d.statut_presence,
    d.date_start,
    d.date_end
FROM DISTRIBUTION d
JOIN ESPÈCE e ON d.id_espece = e.id_espece
JOIN PAYS p ON d.id_pays = p.id_pays
ORDER BY p.continent, e.nom_commun;

-- ============================================================================
-- FIN DU SCHÉMA
-- ============================================================================

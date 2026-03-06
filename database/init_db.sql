-- =====================================
-- SUPPRESSION DES TABLES
-- =====================================

DROP TABLE IF EXISTS espece;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS famille;
DROP TABLE IF EXISTS ordre;

-- =====================================
-- CREATION DES TABLES
-- =====================================

CREATE TABLE ordre (
    id_ordre INT PRIMARY KEY,
    nom VARCHAR(100)
);

CREATE TABLE famille (
    id_famille INT PRIMARY KEY,
    nom VARCHAR(100),
    id_ordre INT,
    FOREIGN KEY (id_ordre) REFERENCES ordre(id_ordre)
);

CREATE TABLE genre (
    id_genre INT PRIMARY KEY,
    nom VARCHAR(100),
    id_famille INT,
    FOREIGN KEY (id_famille) REFERENCES famille(id_famille)
);

CREATE TABLE espece (
    id_espece INT PRIMARY KEY,
    nom_francais VARCHAR(150),
    nom_scientifique VARCHAR(150),
    taille_cm INT,
    poids_g INT,
    habitat VARCHAR(200),
    statut VARCHAR(100),
    id_genre INT,
    FOREIGN KEY (id_genre) REFERENCES genre(id_genre)
);

-- =====================================
-- ORDRES
-- =====================================

INSERT INTO ordre VALUES
(1,'Passeriformes'),
(2,'Accipitriformes'),
(3,'Strigiformes'),
(4,'Falconiformes'),
(5,'Anseriformes'),
(6,'Columbiformes'),
(7,'Piciformes'),
(8,'Charadriiformes');

-- =====================================
-- FAMILLES
-- =====================================

INSERT INTO famille VALUES
(1,'Corvidae',1),
(2,'Paridae',1),
(3,'Turdidae',1),
(4,'Fringillidae',1),
(5,'Accipitridae',2),
(6,'Strigidae',3),
(7,'Falconidae',4),
(8,'Anatidae',5),
(9,'Columbidae',6),
(10,'Picidae',7),
(11,'Laridae',8);

-- =====================================
-- GENRES
-- =====================================

INSERT INTO genre VALUES
(1,'Corvus',1),
(2,'Pica',1),
(3,'Parus',2),
(4,'Cyanistes',2),
(5,'Turdus',3),
(6,'Erithacus',3),
(7,'Fringilla',4),
(8,'Carduelis',4),
(9,'Aquila',5),
(10,'Buteo',5),
(11,'Bubo',6),
(12,'Falco',7),
(13,'Anas',8),
(14,'Cygnus',8),
(15,'Columba',9),
(16,'Streptopelia',9),
(17,'Dendrocopos',10),
(18,'Larus',11);

-- =====================================
-- ESPECES AVEC TAILLE / POIDS / HABITAT
-- =====================================

INSERT INTO espece VALUES
(1,'Grand corbeau','Corvus corax',64,1200,'montagnes, falaises, forêts','préoccupation mineure',1),
(2,'Corneille noire','Corvus corone',48,520,'campagnes, villes, forêts','préoccupation mineure',1),
(3,'Pie bavarde','Pica pica',46,200,'zones ouvertes, jardins','préoccupation mineure',2),

(4,'Mésange charbonnière','Parus major',14,18,'forêts, jardins','préoccupation mineure',3),
(5,'Mésange bleue','Cyanistes caeruleus',12,11,'forêts, parcs','préoccupation mineure',4),

(6,'Merle noir','Turdus merula',25,100,'jardins, forêts','préoccupation mineure',5),
(7,'Grive musicienne','Turdus philomelos',23,90,'forêts, jardins','préoccupation mineure',5),
(8,'Rougegorge familier','Erithacus rubecula',14,17,'jardins, bois','préoccupation mineure',6),

(9,'Pinson des arbres','Fringilla coelebs',15,24,'forêts, campagnes','préoccupation mineure',7),
(10,'Chardonneret élégant','Carduelis carduelis',13,16,'prairies, jardins','préoccupation mineure',8),

(11,'Aigle royal','Aquila chrysaetos',85,4500,'montagnes','quasi menacé',9),
(12,'Buse variable','Buteo buteo',55,800,'campagnes, forêts','préoccupation mineure',10),

(13,'Grand-duc d'Europe','Bubo bubo',70,3000,'falaises, montagnes','préoccupation mineure',11),

(14,'Faucon pèlerin','Falco peregrinus',40,900,'falaises, villes','préoccupation mineure',12),
(15,'Faucon crécerelle','Falco tinnunculus',35,220,'champs, prairies','préoccupation mineure',12),

(16,'Canard colvert','Anas platyrhynchos',60,1100,'lacs, rivières, marais','préoccupation mineure',13),
(17,'Canard siffleur','Anas penelope',50,800,'zones humides','préoccupation mineure',13),

(18,'Cygne tuberculé','Cygnus olor',150,10000,'lacs, étangs','préoccupation mineure',14),

(19,'Pigeon biset','Columba livia',33,350,'falaises, villes','préoccupation mineure',15),
(20,'Tourterelle turque','Streptopelia decaocto',32,200,'villes, campagnes','préoccupation mineure',16),

(21,'Pic épeiche','Dendrocopos major',24,90,'forêts','préoccupation mineure',17),
(22,'Pic vert','Picus viridis',31,180,'prairies, forêts','préoccupation mineure',17),

(23,'Goéland argenté','Larus argentatus',60,1200,'côtes, ports','préoccupation mineure',18),
(24,'Mouette rieuse','Larus ridibundus',38,300,'lacs, côtes','préoccupation mineure',18);

-- Vues
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


-- PARTIE 2 : INSERTION DES DONNÉES

-- TAXONOMIE
INSERT INTO TAXONOMIE (ordre, famille, genre) VALUES
('Passeriformes', 'Corvidae', 'Corvus'),
('Passeriformes', 'Corvidae', 'Pica'),
('Accipitriformes', 'Accipitridae', 'Accipiter'),
('Strigiformes', 'Strigidae', 'Strix'),
('Columbiformes', 'Columbidae', 'Columba'),
('Psittaciformes', 'Psittacidae', 'Ara'),
('Piciformes', 'Picidae', 'Picus'),
('Passeriformes', 'Passeridae', 'Passer'),
('Anseriformes', 'Anatidae', 'Anas'),
('Charadriiformes', 'Laridae', 'Larus');

-- ESPÈCES
INSERT INTO ESPÈCE 
(nom_commun, nom_scientifique, description, hauteur_min, hauteur_max, 
 poids_min, poids_max, envergure, habitat, statut_conservation, id_taxonomie)
VALUES
('Corbeau freux', 'Corvus frugilegus', 'Grand corbeau noir avec zones blanchâtres, nicheur des villes et campagnes', 45, 47, 330, 490, 92, 'Zones urbaines et rurales', 'LC', 1),
('Corneille noire', 'Corvus corone', 'Corbeau entièrement noir, très répandu en Europe occidentale', 42, 46, 330, 580, 93, 'Forêts, parcs, villes', 'LC', 1),
('Pie bavarde', 'Pica pica', 'Oiseau bicolore blanc et noir, reconnaissable à sa longue queue', 40, 51, 140, 250, 52, 'Zones urbaines et rurales', 'LC', 2),
('Autour des palombes', 'Accipiter gentilis', 'Rapace puissant gris et blanc, chasseur agile des petits oiseaux', 43, 64, 330, 1270, 100, 'Forêts et zones boisées', 'LC', 3),
('Chouette hulotte', 'Strix aluco', 'Petite chouette nocturne brune ou grise, imitée dans les histoires fantastiques', 37, 43, 180, 560, 81, 'Forêts, parcs boisés', 'LC', 4),
('Pigeon ramier', 'Columba palumbus', 'Grand pigeon gris avec tache blanche au cou, espèce commune', 40, 42, 320, 510, 75, 'Forêts, champs cultivés', 'LC', 5),
('Ara militaire', 'Ara militaris', 'Grand perroquet vert avec marques rouges et jaunes, endémique Amérique du Sud', 53, 56, 900, 1200, 105, 'Forêts de montagne', 'LC', 6),
('Pic vert', 'Picus viridis', 'Pic moyen vert et jaune avec calotte rouge, commun en Europe', 29, 34, 120, 220, 40, 'Forêts mixtes et claires', 'LC', 7),
('Moineau domestique', 'Passer domesticus', 'Petit passereau brun sympatrique des habitations humaines', 14, 16, 24, 39, 23, 'Zones urbaines et rurales', 'LC', 8),
('Canard colvert', 'Anas platyrhynchos', 'Canard dabchick le plus commun, mâle à tête verte brillante', 51, 67, 750, 1200, 81, 'Lacs, rivières, zones humides', 'LC', 9),
('Mouette rieuse', 'Chroicocephalus ridibundus', 'Petite mouette au masque brun en reproduction, très commune', 35, 37, 210, 350, 86, 'Côtes, lacs, villes littorales', 'LC', 10);

-- AUTEURS
INSERT INTO AUTEUR (nom, prenom, email, bio, site_web) VALUES
('Dupont', 'Marc', 'marc.dupont@ornithologie.fr', 'Ornithologue amateur passionné depuis 20 ans, spécialiste des rapaces', 'www.birdspotting-dupont.fr'),
('Martin', 'Sophie', 'sophie.martin@wildphotos.com', 'Photographe naturaliste professionnelle, expéditions en Afrique et Asie', 'www.sophiemartin-photos.com'),
('Blanc', 'Jean', 'jean.blanc@university.edu', 'Professeur d''ornithologie université, 15 publications scientifiques', 'https://uni.edu/jblanc'),
('Petite', 'Alice', 'alice.petite@birdwatch.org', 'Bénévole association protection des oiseaux, photo aérienne par drone', 'www.alice-wildlife.net'),
('Durand', 'Michel', 'michel.durand@faune.fr', 'Naturaliste généraliste, base de données fotografiques oiseaux Méditerranée', NULL);

-- IMAGES
INSERT INTO IMAGE (id_espece, id_auteur, url_image, description_image, date_prise, localisation, type_image) VALUES
(1, 1, 'images/corbeau_freux_001.jpg', 'Groupe de corbeaux freux en hiver', '2024-01-15', 'Campagne française', 'groupe'),
(1, 2, 'images/corbeau_freux_002.jpg', 'Portrait d''un corbeau freux isolé', '2023-11-22', 'Parc ornithologique', 'profil'),
(2, 1, 'images/corneille_noire_001.jpg', 'Corneille en vol dans la ville', '2024-02-03', 'Toulouse', 'vol'),
(3, 3, 'images/pie_bavarde_001.jpg', 'Pie bavarde sur une branche', '2024-01-28', 'Jardin public', 'profil'),
(3, 4, 'images/pie_bavarde_002.jpg', 'Nid de pie en construction', '2023-04-10', 'Forêt Aquitaine', 'nid'),
(4, 2, 'images/autour_palombes_001.jpg', 'Autour des palombes en piqué de chasse', '2023-09-15', 'Massif Central', 'vol'),
(5, 1, 'images/chouette_hulotte_001.jpg', 'Chouette hulotte grise au crépuscule', '2023-10-30', 'Forêt de Fontainebleau', 'nocturne'),
(6, 4, 'images/pigeon_ramier_001.jpg', 'Pigeon ramier se nourrissant au sol', '2024-02-01', 'Champ cultivé', 'profil'),
(7, 2, 'images/ara_militaire_001.jpg', 'Ara militaire en vol dans la canopée', '2022-06-20', 'Pérou - Vallée du Madre de Dios', 'vol'),
(8, 3, 'images/pic_vert_001.jpg', 'Pic vert en la cavité de nidification', '2023-05-12', 'Forêt mixte Europe', 'nid'),
(9, 5, 'images/moineau_domestique_001.jpg', 'Moineau domestique sur un toit', '2024-01-20', 'Zone urbaine', 'profil'),
(10, 4, 'images/canard_colvert_001.jpg', 'Canard colvert mâle sur l''eau', '2023-12-10', 'Lac urbain', 'profil'),
(11, 2, 'images/mouette_rieuse_001.jpg', 'Mouette rieuse en plumage reproducteur', '2024-03-05', 'Port côtier', 'profil');

-- PAYS
INSERT INTO PAYS (code_iso, nom_pays, continent, population_initiale) VALUES
('FR', 'France', 'Europe', 50000000),
('GB', 'Royaume-Uni', 'Europe', 30000000),
('DE', 'Allemagne', 'Europe', 40000000),
('ES', 'Espagne', 'Europe', 25000000),
('IT', 'Italie', 'Europe', 20000000),
('PE', 'Pérou', 'Amérique du Sud', 1000000),
('BR', 'Brésil', 'Amérique du Sud', 5000000),
('US', 'États-Unis', 'Amérique du Nord', 100000000),
('ZA', 'Afrique du Sud', 'Afrique', 500000),
('AU', 'Australie', 'Océanie', 100000),
('JP', 'Japon', 'Asie', 200000),
('IN', 'Inde', 'Asie', 10000000);

-- DISTRIBUTION
INSERT INTO DISTRIBUTION (id_espece, id_pays, statut_presence, date_start, date_end) VALUES
(1, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(1, 2, 'Résidente', '2024-01-01', '2024-12-31'),
(1, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(1, 4, 'Migrante', '2024-10-01', '2024-03-31'),
(2, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(2, 2, 'Résidente', '2024-01-01', '2024-12-31'),
(2, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(2, 5, 'Résidente', '2024-01-01', '2024-12-31'),
(3, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(3, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(3, 11, 'Résidente', '2024-01-01', '2024-12-31'),
(4, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(4, 2, 'Résidente', '2024-01-01', '2024-12-31'),
(4, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(4, 8, 'Résidente', '2024-01-01', '2024-12-31'),
(5, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(5, 2, 'Résidente', '2024-01-01', '2024-12-31'),
(5, 4, 'Résidente', '2024-01-01', '2024-12-31'),
(6, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(6, 2, 'Migrante', '2024-03-01', '2024-10-31'),
(6, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(7, 6, 'Résidente', '2024-01-01', '2024-12-31'),
(7, 7, 'Résidente', '2024-01-01', '2024-12-31'),
(8, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(8, 3, 'Résidente', '2024-01-01', '2024-12-31'),
(8, 5, 'Résidente', '2024-01-01', '2024-12-31'),
(9, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(9, 8, 'Résidente', '2024-01-01', '2024-12-31'),
(9, 10, 'Résidente', '2024-01-01', '2024-12-31'),
(10, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(10, 8, 'Résidente', '2024-01-01', '2024-12-31'),
(10, 12, 'Migrante', '2024-11-01', '2024-02-28'),
(11, 1, 'Résidente', '2024-01-01', '2024-12-31'),
(11, 2, 'Résidente', '2024-01-01', '2024-12-31'),
(11, 12, 'Migrante', '2024-10-01', '2024-04-30');


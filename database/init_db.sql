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
    longevite_ans INT,
    nombre_individus INT,
    habitat VARCHAR(200),
    statut VARCHAR(100),
    description VARCHAR(500),
    distribution VARCHAR(200),
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
-- ESPECES AVEC LONGÉVITÉ ET POPULATION
-- =====================================

INSERT INTO espece VALUES
(1,'Canard colvert','Anas platyrhynchos',60,1100,10,19000000,'lacs, rivières, marais','Préoccupation mineure','Canard dabchick le plus commun, mâle à tête verte brillante','Holarctique',13),
(2,'Canard siffleur','Anas penelope',50,800,12,2800000,'zones humides','Préoccupation mineure','Petit canard migrateur, mâle avec tête rousse','Europe et Asie',13),
(3,'Cygne tuberculé','Cygnus olor',150,10000,20,600000,'lacs, étangs','Préoccupation mineure','Grand cygne blanc avec tubercule rouge','Europe et Asie',14),
(4,'Faucon crécerelle','Falco tinnunculus',35,220,16,5000000,'champs, prairies','Préoccupation mineure','Petit faucon capable de faire du surplace','Eurasie et Afrique',12),
(5,'Faucon pèlerin','Falco peregrinus',40,900,15,140000,'falaises, villes','Préoccupation mineure','Faucon le plus rapide du monde','Mondiale',12),
(6,'Goéland argenté','Larus argentatus',60,1200,25,1200000,'côtes, ports','Préoccupation mineure','Grand goéland blanc et gris','Atlantique Nord',18),
(7,'Grand-duc d''Europe','Bubo bubo',70,3000,25,250000,'falaises, montagnes','Préoccupation mineure','Plus grand hibou d''Europe','Eurasie',11),
(8,'Mouette rieuse','Larus ridibundus',38,300,30,7500000,'lacs, côtes','Préoccupation mineure','Petite mouette au masque brun en reproduction','Eurasie',18),
(9,'Pic épeiche','Dendrocopos major',24,90,11,73000000,'forêts','Préoccupation mineure','Pic noir et blanc, tambourine sur les troncs','Europe et Asie',17),
(10,'Pic vert','Picus viridis',31,180,15,920000,'prairies, forêts','Préoccupation mineure','Pic moyen vert et jaune avec calotte rouge','Europe',17),
(11,'Pigeon biset','Columba livia',33,350,15,120000000,'falaises, villes','Préoccupation mineure','Pigeon domestique échappé des villes','Mondiale',15),
(12,'Tourterelle turque','Streptopelia decaocto',32,200,15,30000000,'villes, campagnes','Préoccupation mineure','Tourterelle grise avec collier noir','Europe et Asie',16);

-- Vues
CREATE VIEW VUE_ESPECES_COMPLETES AS
SELECT 
    e.id_espece,
    e.nom_francais as nom_commun,
    e.nom_scientifique,
    e.description,
    e.taille_cm,
    e.poids_g,
    e.longevite_ans,
    e.nombre_individus,
    e.habitat,
    e.statut as statut_conservation
FROM espece e
ORDER BY e.nom_francais;

CREATE VIEW VUE_HABITATS AS
SELECT DISTINCT habitat FROM espece ORDER BY habitat;


-- PARTIE 2 : INSERTION DES DONNÉES

-- IMAGES
CREATE TABLE image (
    id_image INT PRIMARY KEY,
    id_espece INT,
    titre VARCHAR(200),
    url VARCHAR(500),
    description VARCHAR(1000),
    FOREIGN KEY (id_espece) REFERENCES espece(id_espece)
);

INSERT INTO image VALUES
(1, 1, 'Canard colvert mâle', 'images/canard_colvert_001.jpg', 'Canard colvert mâle sur l''eau'),
(2, 2, 'Canard siffleur', 'images/canard_siffleur_001.jpg', 'Canard siffleur mâle en plumage nuptial'),
(3, 3, 'Cygne tuberculé', 'images/cygne_tubercule_001.jpg', 'Cygne tuberculé blanc majestueux'),
(4, 4, 'Faucon crécerelle', 'images/faucon_crecerelle_001.jpg', 'Faucon crécerelle en vol stationnaire'),
(5, 5, 'Faucon pèlerin', 'images/faucon_pelerin_001.jpg', 'Faucon pèlerin sur falaise'),
(6, 6, 'Goéland argenté', 'images/goeland_argente_001.jpg', 'Goéland argenté sur rocher côtier'),
(7, 7, 'Grand-duc d''Europe', 'images/grand_duc_001.jpg', 'Grand-duc d''Europe au crépuscule'),
(8, 8, 'Mouette rieuse', 'images/mouette_rieuse_001.jpg', 'Mouette rieuse en plumage reproducteur'),
(9, 9, 'Pic épeiche', 'images/pic_epeiche_001.jpg', 'Pic épeiche en action de tambourinage'),
(10, 10, 'Pic vert', 'images/pic_vert_001.jpg', 'Pic vert à l''entrée de sa cavité'),
(11, 11, 'Pigeon biset', 'images/pigeon_biset_001.jpg', 'Groupe de pigeons bisets en ville'),
(12, 12, 'Tourterelle turque', 'images/tourterelle_turque_001.jpg', 'Tourterelle turque sur câble électrique');


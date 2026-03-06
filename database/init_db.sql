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
(1,'Grand corbeau','Corvus corax',64,1200,20,5000000,'montagnes, falaises, forêts','Préoccupation mineure','Grand corbeau noir, le plus grand des corvidés','Holarctique',1),
(2,'Corneille noire','Corvus corone',48,520,18,8000000,'campagnes, villes, forêts','Préoccupation mineure','Corbeau entièrement noir, très répandu','Europe',1),
(3,'Pie bavarde','Pica pica',46,200,17,3000000,'zones ouvertes, jardins','Préoccupation mineure','Oiseau bicolore blanc et noir avec longue queue','Eurasie',2),
(4,'Mésange charbonnière','Parus major',14,18,12,40000000,'forêts, jardins','Préoccupation mineure','Petit passereau avec calotte noire','Eurasie',3),
(5,'Mésange bleue','Cyanistes caeruleus',12,11,10,50000000,'forêts, parcs','Préoccupation mineure','Petit passereau bleu et jaune','Europe et Asie',4),
(6,'Merle noir','Turdus merula',25,100,15,100000000,'jardins, forêts','Préoccupation mineure','Merle noir avec bec orange, chanteur renommé','Eurasie et Afrique',5),
(7,'Grive musicienne','Turdus philomelos',23,90,14,30000000,'forêts, jardins','Préoccupation mineure','Grive brune avec poitrine tachetée','Europe et Asie',5),
(8,'Rougegorge familier','Erithacus rubecula',14,17,12,25000000,'jardins, bois','Préoccupation mineure','Petit oiseau avec poitrine rouge caractéristique','Europe et Asie',6),
(9,'Pinson des arbres','Fringilla coelebs',15,24,13,50000000,'forêts, campagnes','Préoccupation mineure','Petit passereau aux ailes bleues','Europe et Asie',7),
(10,'Chardonneret élégant','Carduelis carduelis',13,16,11,60000000,'prairies, jardins','Préoccupation mineure','Petit passereau coloré très élégant','Europe et Asie',8),
(11,'Aigle royal','Aquila chrysaetos',85,4500,30,3000000,'montagnes','Quasi menacé','Grand rapace majestueux des montagnes','Holarctique',9),
(12,'Buse variable','Buteo buteo',55,800,20,2000000,'campagnes, forêts','Préoccupation mineure','Rapace commun aux ailes larges','Eurasie et Afrique',10),
(13,'Canard colvert','Anas platyrhynchos',60,1100,10,19000000,'lacs, rivières, marais','Préoccupation mineure','Canard le plus commun, mâle à tête verte','Holarctique',19),
(14,'Canard siffleur','Anas penelope',50,800,12,2800000,'zones humides','Préoccupation mineure','Petit canard migrateur au sifflement caractéristique','Eurasie et Afrique',19),
(15,'Cygne tuberculé','Cygnus olor',150,10000,20,600000,'lacs, étangs','Préoccupation mineure','Grand cygne blanc majestueux','Europe et Asie',20),
(16,'Faucon crécerelle','Falco tinnunculus',35,220,16,5000000,'champs, prairies','Préoccupation mineure','Petit faucon en vol stationnaire','Eurasie et Afrique',21),
(17,'Faucon pèlerin','Falco peregrinus',40,900,15,140000,'falaises, villes','Préoccupation mineure','Faucon le plus rapide du monde en piqué','Mondiale',21),
(18,'Goéland argenté','Larus argentatus',60,1200,25,1200000,'côtes, ports','Préoccupation mineure','Grand goéland blanc et gris','Atlantique Nord',22),
(19,'Grand-duc d''Europe','Bubo bubo',70,3000,25,250000,'falaises, montagnes','Préoccupation mineure','Plus grand hibou d''Europe','Eurasie',11),
(20,'Mouette rieuse','Larus ridibundus',38,300,30,7500000,'lacs, côtes','Préoccupation mineure','Petite mouette au masque brun en nuptial','Eurasie',22),
(21,'Pic épeiche','Dendrocopos major',24,90,11,73000000,'forêts','Préoccupation mineure','Pic noir et blanc, tambourine bruyamment','Europe et Asie',23),
(22,'Pic vert','Picus viridis',31,180,15,920000,'prairies, forêts','Préoccupation mineure','Pic moyen vert et jaune avec calotte rouge','Europe',23),
(23,'Pigeon biset','Columba livia',33,350,15,120000000,'falaises, villes','Préoccupation mineure','Pigeon domestique échappé des villes','Mondiale',24),
(24,'Tourterelle turque','Streptopelia decaocto',32,200,15,30000000,'villes, campagnes','Préoccupation mineure','Tourterelle grise avec collier noir','Europe et Asie',24);

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
(1, 1, 'Grand corbeau perché', 'images/grand_corbeau_001.jpg', 'Grand corbeau noir majestueux'),
(2, 1, 'Corneille noire en vol', 'images/corneille_noire_001.jpg', 'Corneille noire en vol'),
(3, 1, 'Pie bavarde sur branche', 'images/pie_bavarde_001.jpg', 'Pie bavarde bicolore'),
(4, 1, 'Mésange charbonnière', 'images/mesange_charb_001.jpg', 'Mésange charbonnière au mangeoire'),
(5, 1, 'Mésange bleue', 'images/mesange_bleue_001.jpg', 'Mésange bleue coloriée'),
(6, 1, 'Merle noir chanteur', 'images/merle_noir_001.jpg', 'Merle noir sur rocher'),
(7, 1, 'Grive musicienne', 'images/grive_music_001.jpg', 'Grive musicienne au sol'),
(8, 1, 'Rougegorge familier', 'images/rougegorge_001.jpg', 'Rougegorge avec poitrine rouge'),
(9, 1, 'Pinson des arbres', 'images/pinson_001.jpg', 'Pinson des arbres en plumage nuptial'),
(10, 1, 'Chardonneret élégant', 'images/chardonneret_001.jpg', 'Chardonneret coloré très élégant'),
(11, 2, 'Aigle royal en vol', 'images/aigle_royal_001.jpg', 'Aigle royal majestueux en vol'),
(12, 2, 'Buse variable', 'images/buse_var_001.jpg', 'Buse variable perchée'),
(13, 3, 'Canard colvert mâle', 'images/canard_colvert_001.jpg', 'Canard colvert mâle sur l''eau'),
(14, 3, 'Canard siffleur', 'images/canard_siffleur_001.jpg', 'Canard siffleur en plumage nuptial'),
(15, 2, 'Cygne tuberculé', 'images/cygne_tubercule_001.jpg', 'Cygne tuberculé majestueux'),
(16, 1, 'Faucon crécerelle en vol', 'images/faucon_crecerelle_001.jpg', 'Faucon crécerelle en vol stationnaire'),
(17, 2, 'Faucon pèlerin', 'images/faucon_pelerin_001.jpg', 'Faucon pèlerin sur falaise'),
(18, 3, 'Goéland argenté', 'images/goeland_argente_001.jpg', 'Goéland argenté sur rocher'),
(19, 1, 'Grand-duc d''Europe', 'images/grand_duc_001.jpg', 'Grand-duc au crépuscule'),
(20, 2, 'Mouette rieuse', 'images/mouette_rieuse_001.jpg', 'Mouette rieuse en plumage reproducteur'),
(21, 1, 'Pic épeiche', 'images/pic_epeiche_001.jpg', 'Pic épeiche en tambourinage'),
(22, 1, 'Pic vert', 'images/pic_vert_001.jpg', 'Pic vert à sa cavité'),
(23, 3, 'Pigeon biset en ville', 'images/pigeon_biset_001.jpg', 'Groupe de pigeons bisets'),
(24, 2, 'Tourterelle turque', 'images/tourterelle_turque_001.jpg', 'Tourterelle turque sur câble');


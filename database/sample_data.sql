-- ============================================================================
-- DONNÉES D'EXEMPLE : ENCYCLOPÉDIE DES OISEAUX
-- ============================================================================

-- ============================================================================
-- INSERTION TAXONOMIE
-- ============================================================================
INSERT INTO TAXONOMIE (ordre, famille, genre) VALUES
('Passeriformes', 'Corvidae', 'Corvus'),           -- Corbeaux/Corneilles
('Passeriformes', 'Corvidae', 'Pica'),             -- Pies
('Accipitriformes', 'Accipitridae', 'Accipiter'),  -- Autours
('Strigiformes', 'Strigidae', 'Strix'),            -- Chouettes
('Columbiformes', 'Columbidae', 'Columba'),        -- Pigeons
('Psittaciformes', 'Psittacidae', 'Ara'),          -- Aras (Perroquets)
('Piciformes', 'Picidae', 'Picus'),                -- Pics
('Passeriformes', 'Passeridae', 'Passer'),         -- Moineaux
('Anseriformes', 'Anatidae', 'Anas'),              -- Canards
('Charadriiformes', 'Laridae', 'Larus'),           -- Mouettes/Goélands
('Accipitriformes', 'Falconidae', 'Falco'),        -- Faucons
('Anseriformes', 'Anatidae', 'Cygnus'),            -- Cygnes
('Strigiformes', 'Strigidae', 'Bubo'),             -- Grand-ducs
('Piciformes', 'Picidae', 'Dendrocopos'),          -- Pics épeiche
('Columbiformes', 'Columbidae', 'Streptopelia');   -- Tourterelles

-- ============================================================================
-- INSERTION ESPÈCES
-- ============================================================================
INSERT INTO ESPÈCE 
(nom_commun, nom_scientifique, description, hauteur_min, hauteur_max, 
 poids_min, poids_max, envergure, longevite_ans, nombre_individus, habitat, statut_conservation, id_taxonomie)
VALUES

-- Corbeaux/Corneilles
('Corbeau freux', 'Corvus frugilegus', 
 'Grand corbeau noir avec zones blanchâtres, nicheur des villes et campagnes',
 45, 47, 330, 490, 92, 20, 5000000, 'Zones urbaines et rurales', 'LC', 1),

('Corneille noire', 'Corvus corone',
 'Corbeau entièrement noir, très répandu en Europe occidentale',
 42, 46, 330, 580, 93, 18, 8000000, 'Forêts, parcs, villes', 'LC', 1),

-- Pies
('Pie bavarde', 'Pica pica',
 'Oiseau bicolore blanc et noir, reconnaissable à sa longue queue',
 40, 51, 140, 250, 52, 17, 3000000, 'Zones urbaines et rurales', 'LC', 2),

-- Autours
('Autour des palombes', 'Accipiter gentilis',
 'Rapace puissant gris et blanc, chasseur agile des petits oiseaux',
 43, 64, 330, 1270, 100, 19, 300000, 'Forêts et zones boisées', 'LC', 3),

-- Chouettes
('Chouette hulotte', 'Strix aluco',
 'Petite chouette nocturne brune ou grise, imitée dans les histoires fantastiques',
 37, 43, 180, 560, 81, 20, 1000000, 'Forêts, parcs boisés', 'LC', 4),

-- Pigeons
('Pigeon ramier', 'Columba palumbus',
 'Grand pigeon gris avec tache blanche au cou, espèce commune',
 40, 42, 320, 510, 75, 16, 10000000, 'Forêts, champs cultivés', 'LC', 5),

('Pigeon biset', 'Columba livia',
 'Pigeon domestique échappé des villes, omnivore et cosmopolite',
 25, 26, 230, 380, 64, 15, 120000000, 'Zones urbaines', 'LC', 5),

-- Aras
('Ara militaire', 'Ara militaris',
 'Grand perroquet vert avec marques rouges et jaunes, endémique Amérique du Sud',
 53, 56, 900, 1200, 105, 50, 50000, 'Forêts de montagne', 'LC', 6),

-- Pics
('Pic vert', 'Picus viridis',
 'Pic moyen vert et jaune avec calotte rouge, commun en Europe',
 29, 34, 120, 220, 40, 15, 920000, 'Forêts mixtes et claires', 'LC', 7),

('Pic épeiche', 'Dendrocopos major',
 'Pic noir et blanc, tambourine bruyamment sur les troncs',
 23, 26, 70, 180, 34, 11, 73000000, 'Forêts et boisements', 'LC', 14),

-- Moineaux
('Moineau domestique', 'Passer domesticus',
 'Petit passereau brun sympatrique des habitations humaines',
 14, 16, 24, 39, 23, 13, 5000000000, 'Zones urbaines et rurales', 'LC', 8),

-- Canards
('Canard colvert', 'Anas platyrhynchos',
 'Canard dabchick le plus commun, mâle à tête verte brillante',
 51, 67, 750, 1200, 81, 10, 19000000, 'Lacs, rivières, zones humides', 'LC', 9),

('Canard siffleur', 'Anas penelope',
 'Petit canard migrateur, mâle avec tête rousse caractéristique',
 45, 51, 450, 750, 80, 12, 2800000, 'Zones humides côtières', 'LC', 9),

-- Cygnes
('Cygne tuberculé', 'Cygnus olor',
 'Grand cygne blanc avec tubercule rouge à la base du bec',
 140, 160, 7000, 15000, 200, 20, 600000, 'Lacs, rivières, côtes', 'LC', 12),

-- Faucons
('Faucon crécerelle', 'Falco tinnunculus',
 'Petit faucon capable de faire du surplace, chasseur de rongeurs',
 32, 35, 136, 314, 71, 16, 5000000, 'Zones ouvertes et urbaines', 'LC', 11),

('Faucon pèlerin', 'Falco peregrinus',
 'Faucon le plus rapide du monde, se nourrit d''oiseaux en vol',
 34, 58, 330, 1000, 80, 15, 140000, 'Falaises et villes', 'LC', 11),

-- Goélands et Mouettes
('Goéland argenté', 'Larus argentatus',
 'Grand goéland blanc et gris, très adapté aux zones côtières',
 55, 67, 750, 1200, 138, 25, 1200000, 'Côtes et zones urbaines', 'LC', 10),

('Mouette rieuse', 'Chroicocephalus ridibundus',
 'Petite mouette au masque brun en reproduction, très commune',
 35, 37, 210, 350, 86, 30, 7500000, 'Côtes, lacs, villes littorales', 'LC', 10),

-- Grand-duc
('Grand-duc d''Europe', 'Bubo bubo',
 'Plus grand hibou d''Europe, rapace nocturne puissant',
 58, 71, 848, 3200, 188, 25, 250000, 'Falaises et forêts montagnuses', 'LC', 13),

-- Tourterelle
('Tourterelle turque', 'Streptopelia decaocto',
 'Tourterelle grise avec collier noir, espèce invasive en Europe',
 27, 29, 125, 240, 48, 15, 30000000, 'Zones urbaines et rurales', 'LC', 15);

-- ============================================================================
-- INSERTION AUTEURS
-- ============================================================================
INSERT INTO AUTEUR (nom, prenom, email, bio, site_web) VALUES

('Dupont', 'Marc',
 'marc.dupont@ornithologie.fr',
 'Ornithologue amateur passionné depuis 20 ans, spécialiste des rapaces',
 'www.birdspotting-dupont.fr'),

('Martin', 'Sophie',
 'sophie.martin@wildphotos.com',
 'Photographe naturaliste professionnelle, expéditions en Afrique et Asie',
 'www.sophiemartin-photos.com'),

('Blanc', 'Jean',
 'jean.blanc@university.edu',
 'Professeur d''ornithologie université, 15 publications scientifiques',
 'https://uni.edu/jblanc'),

('Petite', 'Alice',
 'alice.petite@birdwatch.org',
 'Bénévole association protection des oiseaux, photo aérienne par drone',
 'www.alice-wildlife.net'),

('Durand', 'Michel',
 'michel.durand@faune.fr',
 'Naturaliste généraliste, base de données fotografiques oiseaux Méditerranée',
 NULL);

-- ============================================================================
-- INSERTION IMAGES
-- ============================================================================
INSERT INTO IMAGE (id_espece, id_auteur, url_image, description_image, 
                   date_prise, localisation, type_image) VALUES

-- Corbeau freux (1)
(1, 1, 'images/corbeau_freux_001.jpg', 'Groupe de corbeaux freux en hiver', 
 '2024-01-15', 'Campagne française', 'groupe'),

(1, 2, 'images/corbeau_freux_002.jpg', 'Portrait d''un corbeau freux isolé', 
 '2023-11-22', 'Parc ornithologique', 'profil'),

-- Corneille noire (2)
(2, 1, 'images/corneille_noire_001.jpg', 'Corneille en vol dans la ville', 
 '2024-02-03', 'Toulouse', 'vol'),

-- Pie bavarde (3)
(3, 3, 'images/pie_bavarde_001.jpg', 'Pie bavarde sur une branche', 
 '2024-01-28', 'Jardin public', 'profil'),

(3, 4, 'images/pie_bavarde_002.jpg', 'Nid de pie en construction', 
 '2023-04-10', 'Forêt Aquitaine', 'nid'),

-- Autour des palombes (4)
(4, 2, 'images/autour_palombes_001.jpg', 'Autour des palombes en piqué de chasse', 
 '2023-09-15', 'Massif Central', 'vol'),

-- Chouette hulotte (5)
(5, 1, 'images/chouette_hulotte_001.jpg', 'Chouette hulotte grise au crépuscule', 
 '2023-10-30', 'Forêt de Fontainebleau', 'nocturne'),

-- Pigeon ramier (6)
(6, 4, 'images/pigeon_ramier_001.jpg', 'Pigeon ramier se nourrissant au sol', 
 '2024-02-01', 'Champ cultivé', 'profil'),

-- Pigeon biset (7)
(7, 4, 'images/pigeon_biset_001.jpg', 'Groupe de pigeons bisets en ville', 
 '2024-01-10', 'Place centrale', 'groupe'),

-- Ara militaire (8)
(8, 2, 'images/ara_militaire_001.jpg', 'Ara militaire en vol dans la canopée', 
 '2022-06-20', 'Pérou - Vallée du Madre de Dios', 'vol'),

-- Pic vert (9)
(9, 3, 'images/pic_vert_001.jpg', 'Pic vert à l''entrée de sa cavité', 
 '2023-05-12', 'Forêt mixte Europe', 'nid'),

-- Pic épeiche (10)
(10, 3, 'images/pic_epeiche_001.jpg', 'Pic épeiche en action de tambourinage', 
 '2023-06-15', 'Forêt de conifères', 'vol'),

-- Moineau domestique (11)
(11, 5, 'images/moineau_domestique_001.jpg', 'Moineau domestique sur un toit', 
 '2024-01-20', 'Zone urbaine', 'profil'),

-- Canard colvert (12)
(12, 4, 'images/canard_colvert_001.jpg', 'Canard colvert mâle sur l''eau', 
 '2023-12-10', 'Lac urbain', 'profil'),

(12, 4, 'images/canard_colvert_002.jpg', 'Couple de canards colverts',
 '2024-01-05', 'Étang de campagne', 'groupe'),

-- Canard siffleur (13)
(13, 1, 'images/canard_siffleur_001.jpg', 'Canard siffleur mâle en plumage nuptial',
 '2023-11-15', 'Réserve ornithologique', 'profil'),

-- Cygne tuberculé (14)
(14, 2, 'images/cygne_tubercule_001.jpg', 'Cygne tuberculé blanc majestueux',
 '2024-02-20', 'Lac ornithologique', 'profil'),

-- Faucon crécerelle (15)
(15, 1, 'images/faucon_crecerelle_001.jpg', 'Faucon crécerelle en vol stationnaire',
 '2023-10-12', 'Campagne', 'vol'),

-- Faucon pèlerin (16)
(16, 2, 'images/faucon_pelerin_001.jpg', 'Faucon pèlerin sur falaise',
 '2023-08-20', 'Falaise calcaire', 'profil'),

-- Goéland argenté (17)
(17, 3, 'images/goeland_argente_001.jpg', 'Goéland argenté sur rocher côtier',
 '2024-03-10', 'Port côtier', 'profil'),

-- Mouette rieuse (18)
(18, 2, 'images/mouette_rieuse_001.jpg', 'Mouette rieuse en plumage reproducteur', 
 '2024-03-05', 'Port côtier', 'profil'),

-- Grand-duc d''Europe (19)
(19, 1, 'images/grand_duc_001.jpg', 'Grand-duc d''Europe au crépuscule',
 '2023-09-25', 'Falaise de montagne', 'nocturne'),

-- Tourterelle turque (20)
(20, 5, 'images/tourterelle_turque_001.jpg', 'Tourterelle turque sur câble électrique',
 '2024-02-14', 'Zone urbaine', 'profil');

-- ============================================================================
-- INSERTION PAYS
-- ============================================================================
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

-- ============================================================================
-- INSERTION DISTRIBUTION
-- ============================================================================
INSERT INTO DISTRIBUTION (id_espece, id_pays, statut_presence, date_start, date_end) VALUES

-- Corbeau freux (1) - Europe de l'Ouest
(1, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(1, 2, 'Résidente', '2024-01-01', '2024-12-31'),  -- Royaume-Uni
(1, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne
(1, 4, 'Migrante', '2024-10-01', '2024-03-31'),   -- Espagne (hivernage)

-- Corneille noire (2) - Europe
(2, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(2, 2, 'Résidente', '2024-01-01', '2024-12-31'),  -- Royaume-Uni
(2, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne
(2, 5, 'Résidente', '2024-01-01', '2024-12-31'),  -- Italie

-- Pie bavarde (3) - Europe et Asie
(3, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(3, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne
(3, 11, 'Résidente', '2024-01-01', '2024-12-31'), -- Japon

-- Autour des palombes (4) - Hémisphère nord
(4, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(4, 2, 'Résidente', '2024-01-01', '2024-12-31'),  -- Royaume-Uni
(4, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne
(4, 8, 'Résidente', '2024-01-01', '2024-12-31'),  -- États-Unis

-- Chouette hulotte (5) - Europe occidentale
(5, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(5, 2, 'Résidente', '2024-01-01', '2024-12-31'),  -- Royaume-Uni
(5, 4, 'Résidente', '2024-01-01', '2024-12-31'),  -- Espagne

-- Pigeon ramier (6) - Europe
(6, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(6, 2, 'Migrante', '2024-03-01', '2024-10-31'),   -- Royaume-Uni (saisonnière)
(6, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne

-- Ara militaire (7) - Amérique du Sud
(7, 6, 'Résidente', '2024-01-01', '2024-12-31'),  -- Pérou
(7, 7, 'Résidente', '2024-01-01', '2024-12-31'),  -- Brésil

-- Pic vert (8) - Europe
(8, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(8, 3, 'Résidente', '2024-01-01', '2024-12-31'),  -- Allemagne
(8, 5, 'Résidente', '2024-01-01', '2024-12-31'),  -- Italie

-- Moineau domestique (9) - Cosmopolite
(9, 1, 'Résidente', '2024-01-01', '2024-12-31'),  -- France
(9, 8, 'Résidente', '2024-01-01', '2024-12-31'),  -- États-Unis
(9, 10, 'Résidente', '2024-01-01', '2024-12-31'), -- Australie

-- Canard colvert (10) - Holarctique
(10, 1, 'Résidente', '2024-01-01', '2024-12-31'), -- France
(10, 8, 'Résidente', '2024-01-01', '2024-12-31'), -- États-Unis
(10, 12, 'Migrante', '2024-11-01', '2024-02-28'), -- Inde (hivernage)

-- Mouette rieuse (11) - Eurasia
(11, 1, 'Résidente', '2024-01-01', '2024-12-31'), -- France
(11, 2, 'Résidente', '2024-01-01', '2024-12-31'), -- Royaume-Uni
(11, 12, 'Migrante', '2024-10-01', '2024-04-30'); -- Inde (hivernage)

-- ============================================================================
-- FIN DONNÉES D'EXEMPLE
-- ============================================================================

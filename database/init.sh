
 Encyclopédie des Oiseaux

echo " Encyclopédie des Oiseaux - Initialisation BD"


 Vérifier SQLite
if ! command -v sqlite &> /dev/null; then
 echo " SQLite n'est pas installé"
 echo "Installation sur Windows: choco install sqlite"
 echo "Installation sur Mac: brew install sqlite"
 echo "Installation sur Linux: apt-get install sqlite"
 exit 
fi

echo " SQLite détecté"
echo ""

 Créer la BD
DB_FILE="database/oiseaux.db"
INIT_SCRIPT="database/init_db.sql"

if [ ! -f "$INIT_SCRIPT" ]; then
 echo " Fichier $INIT_SCRIPT introuvable"
 exit 
fi

echo " Initialisation de la base de données..."
echo " Fichier: $DB_FILE"
echo ""

 Supprimer l'ancienne BD si elle existe
if [ -f "$DB_FILE" ]; then
 echo " Réinitialisation de la BD existante..."
 rm "$DB_FILE"
fi

 Créer la nouvelle BD
sqlite "$DB_FILE" < "$INIT_SCRIPT"

if [ $? -eq ]; then
 echo " Base de données créée avec succès!"
 echo ""
 
 Afficher quelques statistiques
 echo " Statistiques de la BD :"
 echo " Espèces: $(sqlite $DB_FILE 'SELECT COUNT() FROM ESPÈCE;')"
 echo " Images: $(sqlite $DB_FILE 'SELECT COUNT() FROM IMAGE;')"
 echo " Auteurs: $(sqlite $DB_FILE 'SELECT COUNT() FROM AUTEUR;')"
 echo " Pays: $(sqlite $DB_FILE 'SELECT COUNT() FROM PAYS;')"
 echo ""
 
 Test requête simple
 echo " Test - Toutes les espèces :"
 sqlite $DB_FILE "SELECT nom_commun, statut_conservation FROM ESPÈCE ORDER BY nom_commun LIMIT ;"
 
 echo ""
 echo " Fichier BD créé: $DB_FILE"
 echo " Pour explorer: sqlite $DB_FILE"
 echo " Pour tester requêtes: sqlite $DB_FILE < database/advanced_queries.sql"
else
 echo " Erreur lors de l'initialisation de la BD"
 exit 
fi

echo ""
echo " Configuration terminée!"

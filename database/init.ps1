
# Encyclopédie des Oiseaux

Write-Host " Encyclopédie des Oiseaux - Initialisation BD" -ForegroundColor Cyan

# Chemins
$dbFile = "database/oiseaux.db"
$initScript = "database/init_db.sql"

# Vérifier SQLite
try {
    $sqlite = (Get-Command sqlite3 -ErrorAction Stop).Source
    Write-Host " SQLite3 détecté: $sqlite" -ForegroundColor Green
} catch {
    Write-Host " SQLite3 n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    Write-Host "   - Télécharger depuis: https://www.sqlite.org/download.html"
    Write-Host "   - Ou via Choco: choco install sqlite"
    exit 1
}

Write-Host ""

# Vérifier fichier d'init
if (-not (Test-Path $initScript)) {
    Write-Host " Fichier $initScript introuvable" -ForegroundColor Red
    exit 1
}

Write-Host " Initialisation de la base de données..." -ForegroundColor Yellow
Write-Host "   Fichier: $dbFile"
Write-Host ""

# Supprimer l'ancienne BD
if (Test-Path $dbFile) {
    Write-Host " Réinitialisation de la BD existante..." -ForegroundColor Yellow
    Remove-Item $dbFile -Force
}

# Créer la nouvelle BD
Write-Host " Création base de données..." -ForegroundColor Yellow
try {
    sqlite3 $dbFile ".read $initScript" 2>&1 | Out-Host
    
    Write-Host " Base de données créée avec succès!" -ForegroundColor Green
    Write-Host ""
    
    # Afficher statistiques
    Write-Host " Statistiques de la BD :" -ForegroundColor Cyan
    
    $especes = (sqlite3 $dbFile "SELECT COUNT(*) FROM ESPÈCE;")
    $images = (sqlite3 $dbFile "SELECT COUNT(*) FROM IMAGE;")
    $auteurs = (sqlite3 $dbFile "SELECT COUNT(*) FROM AUTEUR;")
    $pays = (sqlite3 $dbFile "SELECT COUNT(*) FROM PAYS;")
    
    Write-Host "   Espèces: $especes" -ForegroundColor White
    Write-Host "   Images: $images" -ForegroundColor White
    Write-Host "   Auteurs: $auteurs" -ForegroundColor White
    Write-Host "   Pays: $pays" -ForegroundColor White
    
    Write-Host ""
    
    # Test requête simple
    Write-Host " Test - Premières espèces :" -ForegroundColor Cyan
    sqlite3 -header -column $dbFile "SELECT nom_commun, statut_conservation FROM ESPÈCE ORDER BY nom_commun LIMIT 5;" | Out-Host
    
    Write-Host ""
    Write-Host " Fichier BD créé: $dbFile" -ForegroundColor Green
    Write-Host " Pour explorer interactivement: sqlite3 $dbFile" -ForegroundColor Cyan
    Write-Host " Pour tester requêtes avancées: sqlite3 $dbFile < database/advanced_queries.sql" -ForegroundColor Cyan
    
} catch {
    Write-Host " Erreur lors de l'initialisation: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host " Configuration terminée!" -ForegroundColor Green

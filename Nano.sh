# Installe pyfiglet (si pas déjà fait)
pip install pyfiglet

# Crée le script interactif
cat << 'EOF' > banniere.sh

# Vérifie si pyfiglet est installé
if ! command -v pyfiglet &> /dev/null; then
    echo "❌ pyfiglet n'est pas installé. Tu peux l'installer avec : pip install pyfiglet"
    exit 1
fi

# Demande du texte
read -p "🔤 Quel texte veux-tu afficher ? " TEXT

# Affiche quelques polices utiles
echo "📜 Polices utiles : block, slant, big, banner, bulbhead, doom, isometric1"
read -p "🎨 Choisis une police (laisser vide pour 'standard') : " FONT
FONT=${FONT:-standard}

# Affiche la bannière
echo
echo "🎉 Voici ta bannière :"
pyfiglet -f "$FONT" "$TEXT"

# Propose de sauvegarder
read -p "💾 Voulez-vous enregistrer la bannière dans un fichier ? (o/n) : " SAVE
if [[ "$SAVE" =~ ^[Oo]$ ]]; then
    read -p "📝 Nom du fichier (ex: bannière.txt) : " FILE
    pyfiglet -f "$FONT" "$TEXT" > "$FILE"
    echo "✅ Bannière enregistrée dans '$FILE'"
fi
EOF

# Rend le script exécutable
chmod +x banniere.sh

# Exécute le script
./banniere.sh
# déterminer le niveau pour choisir le nombre aléatoire
echo "Devine un nombre aléatoire, mais d'abord, choisi le niveau de difficulté :"
echo "1 → Facile (1-10)"
echo "2 → Moyen (1-50)"
echo "3 → Difficile (1-100)"

read -p "Ton choix : " niveau

if [ "$niveau" -eq 1 ]; then
  max=10
elif [ "$niveau" -eq 2 ]; then
  max=50
elif [ "$niveau" -eq 3 ]; then
  max=100
else
  echo "Choix invalide, niveau facile par défaut"
  max=10
fi

# Générer le nombre aléatoire entre 1 et le max
nombre=$(( ( RANDOM % max ) + 1 ))

# Demander de deviner le nombre
echo "Devine le nombre aléatoire entre 1 et $max."

# faire taper l'utilisateur, comparer et commpter le nombre d'essais 
compteur=0
while true; do
  compteur=$(( compteur + 1))
 
  read -p "Devine le nombre : " reponse

  if [ "$reponse" -eq "$nombre" ]; then
    echo "Bravo tu as trouvé en $compteur essais !"
    score=$(( max - compteur + 1 ))
    echo "Ton score est : $score"
    break # sortir de la boucle
  elif [ "$reponse" -lt "$nombre" ]; then
    echo "C'est plus grand !"
  else
    echo "C'est plus petit !"
  fi
done
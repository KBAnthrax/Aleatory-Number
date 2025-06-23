# Déterminer un nombre aléatoire
nombre=$(( ( RANDOM % 20 ) + 1 ))

# Demander de deviner le nombre
echo "Devine le nombre aléatoire entre 1 et 20."

# faire taper l'utilisateur et comparer ( mettre le read dans la boucle sinon spam la réponse) + créer la variable compteur avant
compteur=0
while true; do
  compteur=$(( compteur + 1))
 
  read -p "Devine le nombre : " reponse

  if [ "$reponse" -eq "$nombre" ]; then
    echo "Bravo tu as trouvé en $compteur essais !"
    break # sortir de la boucle
  elif [ "$reponse" -lt "$nombre" ]; then
    echo "C'est plus grand !"
  else
    echo "C'est plus petit !"
  fi
done
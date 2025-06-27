# --- Fonction MODE LIBRE ---
mode_libre() {
  echo "======================"
  echo "===  Mode Libre ==="
  echo "Devine un nombre aléatoire, mais d'abord, choisi le niveau de difficulté (1;2;3):"
  echo "----------------------"
  echo "1 → Facile (1-10)"
  echo "2 → Moyen  (1-50)"
  echo "3 → Difficile (1-100)"
  echo "----------------------"
  read -p "Ton choix : " niveau

  case $niveau in
    1) max=10;;
    2) max=50;;
    3) max=100;;
    *) echo "Choix invalide, niveau facile par défaut"; max=10;;
  esac

  nombre=$(( ( RANDOM % max ) + 1 ))
  essais_max=10
  compteur=0
  propositions=""

  echo "======================"
  echo "Devine le nombre aléatoire entre 1 et $max. Attention, tu as $essais_max essais max."
  echo "----------------------"

  while [ "$compteur" -lt "$essais_max" ]; do
    echo ""
    echo "Essais restants : $(( essais_max - compteur ))"
    echo ""
    compteur=$(( compteur + 1 ))

    while true; do
      read -p "Devine le nombre : " reponse
      if [[ "$reponse" =~ ^[0-9]+$ ]] && [ "$reponse" -ge 1 ] && [ "$reponse" -le "$max" ]; then
        break
      else
        echo "----------------------"
        echo "Entrée invalide. Entrez un nombre entre 1 et $max."
        echo "----------------------"
      fi
    done

    echo ""
    propositions="$propositions $reponse"
    echo "---"
    echo "Propositions déjà faites :$propositions"
    echo ""

    if [ "$reponse" -eq "$nombre" ]; then
      echo "Bravo tu as trouvé en $compteur essais !"
      break
    elif [ "$reponse" -lt "$nombre" ]; then
      echo "C'est plus grand !"
    else
      echo "C'est plus petit !"
    fi
    echo "---"
  done

  if [ "$reponse" -ne "$nombre" ]; then
    echo "Tu as perdu ! Le nombre était : $nombre"
  fi

  echo "======================"
  read -p "Rejouer ? (oui/non) ou taper m pour retourner au menu : " choix

  if [ "$choix" = "oui" ]; then
    mode_libre
  elif [ "$choix" = "m" ]; then
    menu
  else
    echo "À bientôt !"
    exit
  fi
}

# --- Fonction jouer_niveau ---
jouer_niveau() {
  local niveau=$1
  local max=$2
  local essais_max=$3
  local moyenne=$4

  echo "======================"
  echo "=== Niveau $niveau ==="
  echo "======================"
  echo "=== Round $round / $rounds ==="
  echo "----------------------"

  nombre=$(( ( RANDOM % max ) + 1 ))
  compteur=0
  propositions=""

  echo "Devine un nombre entre 1 et $max. Tu as $essais_max essais."
  echo "----------------------"

  while [ "$compteur" -lt "$essais_max" ]; do
    echo ""
    echo "Essais restants : $(( essais_max - compteur ))"
    echo ""
    compteur=$(( compteur + 1 ))

    while true; do
      read -p "Devine le nombre : " reponse
      if [[ "$reponse" =~ ^[0-9]+$ ]] && [ "$reponse" -ge 1 ] && [ "$reponse" -le "$max" ]; then
        break
      else
        echo "----------------------"
        echo "Entrée invalide. Entrez un nombre entre 1 et $max."
        echo "----------------------"
      fi
    done

    echo ""
    propositions="$propositions $reponse"
    echo "---"
    echo "Propositions déjà faites :$propositions"
    echo ""

    if [ "$reponse" -eq "$nombre" ]; then
      score=$(( 333 * moyenne / compteur ))
      echo "Bravo ! Tu as trouvé en $compteur essais !"
      echo "Tu marques $score points."
      echo "Score actuel : $(( total_score + score )) / $objectif"
      echo ""
      return 0
    elif [ "$reponse" -lt "$nombre" ]; then
      echo "C'est plus grand !"
    else
      echo "C'est plus petit !"
    fi
    echo "---"
  done

  echo "Tu as perdu ! Le nombre était : $nombre"
  score=0
  return 1
}

# --- Fonction MODE AVENTURE ---
mode_aventure() {
  if [ ! -f progression.txt ]; then
    echo 1 > progression.txt
  fi

  niveau_atteint=$(cat progression.txt)

  echo "======================"
  if [ -f succes.txt ] && grep -q "PLATINE" succes.txt; then
    echo "=== Mode Aventure (Platiné) ==="
  else
    echo "=== Mode Aventure ==="
  fi
  echo "----------------------"

  for i in {1..10}; do
    if [ "$i" -le "$niveau_atteint" ]; then
      echo "$i → Niveau $i (Ö déverrouillé)"
    else
      echo "$i → Niveau $i (🔒 verrouillé)"
    fi
  done

  while true; do
    echo "----------------------"
    read -p "Choisis un niveau à jouer (1 à $niveau_atteint) : " niveau_choisi

    if ! [[ "$niveau_choisi" =~ ^[0-9]+$ ]]; then
      echo "----------------------"
      echo "🚫 Saisie invalide : entre un nombre uniquement."
      continue
    fi

    if [ "$niveau_choisi" -gt "$niveau_atteint" ] || [ "$niveau_choisi" -lt 1 ]; then
      echo "----------------------"
      echo "🚫 Ce niveau est verrouillé. Choisis un niveau entre 1 et $niveau_atteint."
      continue
    fi

    break
  done

  echo "----------------------"
  echo "Tu as choisi le niveau $niveau_choisi"

  total_score=0
  rounds=3
  objectif=999

  case $niveau_choisi in
    1)  max=10;  essais_max=5;  moyenne=3;;
    2)  max=30;  essais_max=6;  moyenne=4;;
    3)  max=50;  essais_max=7;  moyenne=5;;
    4)  max=70;  essais_max=8;  moyenne=6;;
    5)  max=90;  essais_max=9;  moyenne=7;;
    6)  max=110; essais_max=10; moyenne=8;;
    7)  max=130; essais_max=11; moyenne=9;;
    8)  max=150; essais_max=12; moyenne=10;;
    9)  max=175; essais_max=13; moyenne=11;;
    10) max=200; essais_max=14; moyenne=12;;
    *)  max=10;  essais_max=5;  moyenne=5;;
  esac

  for round in $(seq 1 $rounds); do
    jouer_niveau "$niveau_choisi" "$max" "$essais_max" "$moyenne"
    if [ $? -eq 0 ]; then
      total_score=$(( total_score + score ))
    else
      echo "Round perdu. Score actuel : $total_score / $objectif"
    fi
    echo "======================"
  done

  echo "Score total pour le niveau $niveau_choisi : $total_score / $objectif"

  if [ "$total_score" -ge "$objectif" ]; then
    echo "Niveau réussi ! Tu débloques le niveau suivant."
    if [ "$niveau_choisi" -lt 10 ]; then
      if [ "$niveau_atteint" -le "$niveau_choisi" ]; then
        echo $(( niveau_choisi + 1 )) > progression.txt
      fi
    elif [ "$niveau_choisi" -eq 10 ]; then
      echo "======================"
      echo "🎉 Bravo, tu as fini le Mode Aventure, tu es maintenant le GOOOOAAATT d'Aleatory Number !!!"
      echo "---"
      echo "🏆 Succès débloqué : Platine d'Aleatory Number"
      echo "PLATINE" > succes.txt
    fi
  else
    echo "Objectif échoué. Essaie encore !"
  fi

  echo "======================"
  read -p "Revenir au Mode Aventure ? (oui/non) ou taper m pour retourner au menu : " choix

  if [ "$choix" = "oui" ]; then
    mode_aventure
  elif [ "$choix" = "m" ]; then
    menu
  else
    echo "À bientôt !"
    exit
  fi
}

# --- Fonction MENU ---
menu() {
  echo "======================"
  echo "=== MENU PRINCIPAL ==="
  echo "= 1 → Mode Libre     ="

  if [ -f succes.txt ] && grep -q "PLATINE" succes.txt; then
    echo "= 2 → Mode Aventure (Platiné)  ="
  else
    echo "= 2 → Mode Aventure  ="
  fi

  echo "----------------------"
  echo "Choisi un mode."
  read -p "- Ton choix : " mode

  case $mode in
    1) mode_libre;;
    2) mode_aventure;;
    *)
      echo "======================"
      echo "Choix invalide, veuillez choisir un mode (1 ou 2)"
      menu;;
  esac
}

# --- Lancer le menu au démarrage ---
menu

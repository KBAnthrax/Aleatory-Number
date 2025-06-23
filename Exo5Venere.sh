 : # --- Message de Bienvenue ---
welcome_screen() {
  clear
  echo "=============================="
  echo "=== Bienvenue dans...     ==="
  echo "===    ALEATORY NUMBER     ==="
  echo "=============================="
  echo ""
  echo "Touche [Entrée] → START"
  echo "Touche [e]      → EXIT"
  echo ""

  read -n1 key
  echo ""

  case "$key" in
    e|E)
      echo ""
      echo "Merci d'avoir joué ! À bientôt !"
      exit 0
      ;;
    *)
      home_screen
      ;;
  esac
}

# --- Home Screen ---
home_screen() {
  clear
  echo "=============================="
  echo "===    ALEATORY NUMBER     ==="
  echo "=============================="
  echo ""
  echo "1 → Nouvelle Partie"
  echo "2 → Continuer"
  echo "3 → Quitter"
  echo ""

  while true; do
    read -p "Ton choix : " choix
    case "$choix" in
      1)
        echo "Es-tu sûr de vouloir réinitialiser ta progression ? (o/n)"
        read -n1 confirmation
        echo ""
        if [[ "$confirmation" =~ ^[oO]$ ]]; then
          rm -f progression.txt succes.txt
          echo 1 > progression.txt
          echo ""
          echo "Progression réinitialisée ! Nouvelle aventure..."
          sleep 1
          menu
        else
          echo "Réinitialisation annulée."
        fi
        break
        ;;
      2)
        if [ ! -f progression.txt ]; then echo 1 > progression.txt; fi
        menu
        break
        ;;
      3)
        echo "Merci d'avoir joué ! À bientôt !"
        exit 0
        ;;
      *)
        echo "Choix invalide. Merci de saisir 1, 2 ou 3."
        ;;
    esac
  done
}

# --- Menu Principal ---
menu() {
  clear
  echo "======================"
  echo "===   MENU PRINCIPAL   ==="
  echo "======================"
  echo "= 1 → Mode Libre           ="

  if [ -f succes.txt ] && grep -q "PLATINE" succes.txt; then
    echo "= 2 → Mode Aventure (Platiné) ="
  else
    echo "= 2 → Mode Aventure         ="
  fi

  echo "= 3 → Quitter vers Home     ="
  echo "======================"
  echo ""

  while true; do
    read -p "Ton choix : " mode
    case "$mode" in
      1) mode_libre; break ;;
      2) mode_aventure; break ;;
      3) home_screen; break ;;
      *) echo "Choix invalide. Merci de saisir 1, 2 ou 3." ;;
    esac
  done
}

# --- Mode Libre ---
mode_libre() {
  clear
  echo "======================"
  echo "       MODE LIBRE       "
  echo "======================"
  echo "Choisis la difficulté :"
  echo "----------------------"
  echo "1 → Facile (1-10)"
  echo "2 → Moyen  (1-50)"
  echo "3 → Difficile (1-100)"
  echo "----------------------"

  while true; do
    read -p "Ton choix : " niveau
    if [[ "$niveau" =~ ^[1-3]$ ]]; then
      break
    else
      echo "Entrée invalide. Merci de saisir 1, 2 ou 3."
    fi
  done

  case $niveau in
    1) max=10 ;;
    2) max=50 ;;
    3) max=100 ;;
  esac

  nombre=$(( ( RANDOM % max ) + 1 ))
  essais_max=10
  compteur=0
  propositions=""

  clear
  echo "=============================="
  echo "Devine le nombre entre 1 et $max"
  echo "Tu as $essais_max essais max"
  echo "------------------------------"
  echo ""

  while [ "$compteur" -lt "$essais_max" ]; do
    essais_restant=$(( essais_max - compteur ))
    echo "Essais restants : $essais_restant"
    echo ""

    while true; do
      read -p "Devine le nombre : " reponse
      if [[ "$reponse" =~ ^[mMhH]$ ]]; then
        case "$reponse" in
          m|M) menu; return ;;
          h|H) home_screen; return ;;
        esac
      elif [[ "$reponse" =~ ^[0-9]+$ ]] && [ "$reponse" -ge 1 ] && [ "$reponse" -le "$max" ]; then
        break
      else
        echo "Entrée invalide. Nombre entre 1 et $max (ou m/h)."
      fi
    done

    compteur=$((compteur + 1))
    propositions="$propositions $reponse"

    echo "---"
    echo "Propositions :$propositions"
    echo "---"

    if [ "$reponse" -eq "$nombre" ]; then
      echo "Bravo, tu as trouvé en $compteur essais !"
      echo "---"
      break
    elif [ "$reponse" -lt "$nombre" ]; then
      echo "C'est plus grand !"
    else
      echo "C'est plus petit !"
    fi
    echo ""
  done

  if [ "$reponse" -ne "$nombre" ]; then
    echo "Tu as perdu ! Le nombre était : $nombre"
  fi

  echo ""
  echo "r → Rejouer | m → Menu | h → Accueil"
  while true; do
    read -p "Ton choix : " choix
    case "$choix" in
      r|R) mode_libre; break ;;
      m|M) menu; break ;;
      h|H) home_screen; break ;;
      *) echo "Entrée invalide. Merci de saisir r, m ou h." ;;
    esac
  done
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
  echo ""
  echo "Devine un nombre entre 1 et $max. Tu as $essais_max essais."
  echo "----------------------"

  nombre=$(( ( RANDOM % max ) + 1 ))
  compteur=0
  propositions=""
  score=0

  while [ "$compteur" -lt "$essais_max" ]; do
    echo ""
    echo "Essais restants : $(( essais_max - compteur ))"
    echo ""

    while true; do
      read -p "Devine le nombre (m=menu, h=home) : " reponse

      if [[ "$reponse" =~ ^[mMhH]$ ]]; then
  case "$reponse" in
    m|M)
      echo "Retour au menu principal..."
      menu
      return 0
      ;;
    h|H)
      echo "Retour à l'accueil..."
      home_screen
      return 0
      ;;
  esac
      elif [[ "$reponse" =~ ^[0-9]+$ ]] && [ "$reponse" -ge 1 ] && [ "$reponse" -le "$max" ]; then
        break
      else
        echo "----------------------"
        echo "Entrée invalide. Entrez un nombre entre 1 et $max (ou m/h)."
        echo "----------------------"
      fi
    done

    echo ""
    compteur=$(( compteur + 1 ))
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

# --- Mode Aventure ---
mode_aventure() {
  if [ ! -f progression.txt ]; then echo 1 > progression.txt; fi
  niveau_atteint=$(cat progression.txt)

  clear
  echo "==========================="
  if [ -f succes.txt ] && grep -q "PLATINE" succes.txt; then
    echo "=== Mode Aventure (Platiné) ==="
  else
    echo "===      Mode Aventure     ==="
  fi
  echo "==========================="
  echo ""

  for i in {1..10}; do
    if [ "$i" -le "$niveau_atteint" ]; then
      echo "$i → Niveau $i (✔️ Déverrouillé)"
    else
      echo "$i → Niveau $i (🔒 Verrouillé)"
    fi
  done

  echo ""
  read -p "Choisis un niveau (1 à $niveau_atteint) : " niveau_choisi

  if ! [[ "$niveau_choisi" =~ ^[0-9]+$ ]] || [ "$niveau_choisi" -lt 1 ] || [ "$niveau_choisi" -gt "$niveau_atteint" ]; then
    echo "Choix invalide. Retour au menu."
    sleep 1
    menu
    return
  fi

  total_score=0
  rounds=3
  objectif=999

  case $niveau_choisi in
    1)  max=10;  essais_max=6;  moyenne=4 ;;
    2)  max=30;  essais_max=7;  moyenne=5 ;;
    3)  max=50;  essais_max=8;  moyenne=6 ;;
    4)  max=70;  essais_max=9;  moyenne=7 ;;
    5)  max=90;  essais_max=10;  moyenne=8 ;;
    6)  max=110; essais_max=11; moyenne=9 ;;
    7)  max=130; essais_max=12; moyenne=10 ;;
    8)  max=150; essais_max=13; moyenne=11 ;;
    9)  max=175; essais_max=14; moyenne=12 ;;
    10) max=200; essais_max=15; moyenne=13 ;;
  esac

  clear
  echo "=============================="
  echo "Niveau $niveau_choisi - Objectif : $objectif pts"
  echo "------------------------------"

  for round in $(seq 1 $rounds); do
    echo ""
    echo "====== Round $round / $rounds ======"
    jouer_niveau "$niveau_choisi" "$max" "$essais_max" "$moyenne"
   ret=$?
if [ $ret -eq 2 ]; then
  echo ""
  echo "m → Menu | h → Accueil"
  while true; do
    read -p "Ton choix : " choix
    case "$choix" in
      m|M) menu; return ;;
      h|H) home_screen; return ;;
      *) echo "Entrée invalide. Merci de saisir m ou h." ;;
    esac
  done
fi
    if [ $ret -eq 0 ]; then
      total_score=$(( total_score + score ))
      echo "Score total actuel : $total_score / $objectif"
    else
      echo "Tu n'as pas réussi ce round."
    fi
  done

  echo ""
  echo "=============================="
  echo "Score final : $total_score / $objectif"
  echo "=============================="

  if [ "$total_score" -ge "$objectif" ]; then
    echo "Félicitations ! Tu as terminé ce niveau !"
    if [ "$niveau_choisi" -lt 10 ]; then
      nouveau_niveau=$(( niveau_choisi + 1 ))
      if [ "$niveau_atteint" -lt "$nouveau_niveau" ]; then
        echo "$nouveau_niveau" > progression.txt
        echo "Niveau $nouveau_niveau débloqué !"
      fi
    else
      echo "Tu as atteint le niveau maximal !"
      if ! grep -q "PLATINE" succes.txt 2>/dev/null; then
        echo "PLATINE" >> succes.txt
        echo "🏆 Félicitations, tu es PLATINÉ !"
      fi
    fi
  else
    echo "Score insuffisant. Recommence ce niveau."
  fi

 echo ""
  echo "m → Menu | h → Home | r → Revenir au Mode Aventure"
  while true; do
    read -p "Ton choix : " choix
    case "$choix" in
      m|M) menu; return ;;
      h|H) home_screen; return ;;
      r|R) mode_aventure; return ;;
      *) echo "Entrée invalide. Merci de saisir m, h ou q." ;;
    esac
  done
}

# --- Lancement du jeu ---
welcome_screen
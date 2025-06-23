 # --- Couleurs ---
C_DEFAULT='\e[0m'
C_RED='\e[31m'
C_GREEN='\e[32m'
C_YELLOW='\e[33m'
C_BLUE='\033[94m'
C_GRAY='\033[90m'
C_CYAN='\e[36m'

# --- Caractères de boîte ---
BOX_V="║"
BOX_H="═"
BOX_TL="╔"
BOX_TR="╗"
BOX_BL="╚"
BOX_BR="╝"
BOX_ML="╠"
BOX_MR="╣"

# --- Constantes de mise en page ---
WIDTH=40

# --- Fonctions d'affichage ---

# Calcule la longueur visible d'une chaîne (sans les codes ANSI)
get_visible_length() {
    local text="$1"
    local clean_text
    # sed -r 's/\x1B\[[0-9;]*[mK]//g' supprime les codes de couleur
    clean_text=$(echo -e "$text" | sed -r 's/\x1B\[[0-9;]*[mK]//g')
    echo "${#clean_text}"
}

# Affiche une ligne de séparation (═, ─, etc.)
print_separator_line() {
    local char="${1:-═}"
    local left_char="${2:-$BOX_ML}"
    local right_char="${3:-$BOX_MR}"
    echo -e "${C_CYAN}${left_char}$(printf '%*s' "$WIDTH" "" | tr ' ' "$char")${right_char}${C_DEFAULT}"
}

# Affiche une ligne de texte centrée dans une boîte (gère les couleurs ANSI)
print_centered_text() {
    local text="$1"
    local visible_length
    visible_length=$(get_visible_length "$text")
    local padding_total=$((WIDTH - visible_length))
    local padding_left=$((padding_total / 2))
    local padding_right=$((padding_total - padding_left))
    # Utilisation de %b pour interpréter les séquences d'échappement des couleurs
    printf "${C_CYAN}${BOX_V}%*s%b%*s${C_CYAN}${BOX_V}${C_DEFAULT}\n" "$padding_left" "" "$text" "$padding_right" ""
}

# Affiche une ligne de texte alignée à gauche (gère les couleurs ANSI)
print_left_aligned_text() {
    local text="$1"
    local visible_length
    visible_length=$(get_visible_length "$text")
    # On soustrait 2 pour les espaces autour du texte
    local padding=$((WIDTH - 2 - visible_length))
    printf "${C_CYAN}${BOX_V} %b%*s ${C_CYAN}${BOX_V}${C_DEFAULT}\n" "$text" "$padding" ""
}

: # --- Message de Bienvenue ---
welcome_screen() {
  clear
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "Bienvenue dans..."
  print_centered_text "ALEATORY NUMBER"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"
  echo ""
  echo -e "Touche [${C_GREEN}Entrée${C_DEFAULT}] → START"
  echo -e "Touche [${C_RED}e${C_DEFAULT}]      → EXIT"
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
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "ALEATORY NUMBER"
  print_separator_line
  print_left_aligned_text "${C_GREEN}1 → Nouvelle Partie${C_DEFAULT}"
  print_left_aligned_text "${C_YELLOW}2 → Continuer${C_DEFAULT}"
  print_left_aligned_text "${C_RED}3 → Quitter${C_DEFAULT}"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"
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
          home_screen
        else
          echo "Réinitialisation annulée."
          sleep 1
          home_screen
        fi
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
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "MENU PRINCIPAL"
  print_separator_line
  print_left_aligned_text "${C_GREEN}1 → Mode Libre${C_DEFAULT}"
  if [ -f succes.txt ] && grep -q "PLATINE" succes.txt; then
    print_left_aligned_text "${C_YELLOW}2 → Mode Aventure (Platiné)${C_DEFAULT}"
  else
    print_left_aligned_text "${C_YELLOW}2 → Mode Aventure${C_DEFAULT}"
  fi
  print_left_aligned_text "${C_RED}3 → Quitter vers Home${C_DEFAULT}"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"
  echo ""

  while true; do
    read -p "Ton choix : " mode
    case "$mode" in
      1) mode_libre; break ;;
      2) mode_aventure; break ;;
      3) home_screen; break ;;
      *) echo -e "${C_RED}Choix invalide. Merci de saisir 1, 2 ou 3.${C_DEFAULT}" ;;
    esac
  done
}

# --- Mode Libre ---
mode_libre() {
  clear
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "MODE LIBRE"
  print_separator_line
  print_centered_text "Choisis la difficulté"
  print_separator_line "─"
  print_left_aligned_text "${C_GREEN}1 → Facile (1-10)${C_DEFAULT}"
  print_left_aligned_text "${C_YELLOW}2 → Moyen  (1-50)${C_DEFAULT}"
  print_left_aligned_text "${C_RED}3 → Difficile (1-100)${C_DEFAULT}"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"

  while true; do
    read -p "Ton choix : " niveau
    if [[ "$niveau" =~ ^[1-3]$ ]]; then
      break
    else
      echo -e "${C_RED}Entrée invalide. Merci de saisir 1, 2 ou 3.${C_DEFAULT}"
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
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "MODE LIBRE"
  print_separator_line
  echo ""
  echo -e "Devine le nombre entre ${C_YELLOW}1${C_DEFAULT} et ${C_YELLOW}$max${C_DEFAULT}."
  echo -e "Tu as ${C_YELLOW}$essais_max essais${C_DEFAULT}."
  echo ""

  while [ "$compteur" -lt "$essais_max" ]; do
    essais_restant=$(( essais_max - compteur ))
    echo -e "Essais restants : ${C_YELLOW}$essais_restant${C_DEFAULT}"
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
        echo -e "${C_RED}Entrée invalide. Nombre entre 1 et $max (ou m/h).${C_DEFAULT}"
      fi
    done

    compteur=$((compteur + 1))
    propositions="$propositions $reponse"

    echo "───────────────────────────────────"
    echo -e "Propositions :${C_CYAN}$propositions${C_DEFAULT}"
    echo "───────────────────────────────────"

    if [ "$reponse" -eq "$nombre" ]; then
      echo -e "${C_GREEN}Bravo, tu as trouvé en $compteur essais !${C_DEFAULT}"
      echo "---"
      break
    elif [ "$reponse" -lt "$nombre" ]; then
      echo -e "${C_YELLOW}C'est plus grand !${C_DEFAULT}"
    else
      echo -e "${C_YELLOW}C'est plus petit !${C_DEFAULT}"
    fi
    echo ""
  done

  if [ "$reponse" -ne "$nombre" ]; then
    echo -e "${C_RED}Tu as perdu ! Le nombre était : $nombre${C_DEFAULT}"
  fi

  echo ""
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "${C_GREEN}r: Rejouer${C_DEFAULT} | ${C_YELLOW}m: Menu${C_DEFAULT} | ${C_BLUE}h: Home${C_DEFAULT}"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"
  while true; do
    read -p "Ton choix : " choix
    case "$choix" in
      r|R) mode_libre; break ;;
      m|M) menu; break ;;
      h|H) home_screen; break ;;
      *) echo -e "${C_RED}Entrée invalide. Merci de saisir r, m ou h.${C_DEFAULT}" ;;
    esac
  done
}

# --- Fonction jouer_niveau (Aventure) ---
jouer_niveau() {
    local niveau=$1 max=$2 essais_max=$3 moyenne=$4 round_num=$5 total_rounds=$6
    local nombre=$(( (RANDOM % max) + 1 ))
    local compteur=0
    local propositions=""
    local reponse
    local message="Faites votre proposition."

    while [ "$compteur" -lt "$essais_max" ]; do
        clear
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW}NIVEAU $niveau ${C_CYAN}- ROUND $round_num/$total_rounds${C_DEFAULT}"
        print_separator_line
        local essais_restants=$(( essais_max - compteur ))
        print_centered_text "Il vous reste ${C_YELLOW}$essais_restants/${essais_max}${C_DEFAULT} essais."
        print_centered_text "Le nombre est entre ${C_WHITE}1${C_DEFAULT} et ${C_WHITE}$max${C_DEFAULT}."
        if [ -n "$propositions" ]; then
            local last_propositions=$(echo "$propositions" | tr ' ' '\n' | tail -n 5 | tr '\n' ' ')
            print_centered_text "Vos derniers essais: ${C_CYAN}$last_propositions${C_DEFAULT}"
        else
            print_centered_text " "
        fi
        print_separator_line
        print_centered_text "$message"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        
        read -p "Votre proposition (m=menu, h=home) : " reponse

        if [[ "$reponse" =~ ^[mMhH]$ ]]; then
            case "$reponse" in m|M) menu; exit 2 ;; h|H) home_screen; exit 2 ;; esac
        elif ! [[ "$reponse" =~ ^[0-9]+$ ]] || [ "$reponse" -lt 1 ] || [ "$reponse" -gt "$max" ]; then
            message="${C_RED}Entrée invalide. Un nombre entre 1 et $max est attendu.${C_DEFAULT}"
            continue
        fi

        propositions="$propositions $reponse"
        compteur=$((compteur + 1))

        if [ "$reponse" -eq "$nombre" ]; then
            score=$(( 333 * moyenne / compteur ))
            clear
            print_separator_line "═" "$BOX_TL" "$BOX_TR"
            print_centered_text "${C_GREEN}🎉 ROUND GAGNÉ ! 🎉${C_DEFAULT}"
            print_separator_line
            print_centered_text "Vous avez trouvé ${C_YELLOW}$nombre${C_DEFAULT} en ${C_YELLOW}$compteur${C_DEFAULT} essais !"
            print_centered_text "Vous marquez ${C_GREEN}$score${C_DEFAULT} points."
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 2
            return 0
        elif [ "$reponse" -lt "$nombre" ]; then
            message="Le nombre mystère est ${C_YELLOW}PLUS GRAND${C_DEFAULT} !"
        else
            message="Le nombre mystère est ${C_YELLOW}PLUS PETIT${C_DEFAULT} !"
        fi
    done

    clear
    print_separator_line "═" "$BOX_TL" "$BOX_TR"
    print_centered_text "${C_RED}ROUND PERDU${C_DEFAULT}"
    print_separator_line
    print_centered_text "Vous n'avez pas trouvé le nombre à temps."
    print_centered_text "La réponse était ${C_YELLOW}$nombre${C_DEFAULT}."
    print_separator_line "═" "$BOX_BL" "$BOX_BR"
    score=0
    sleep 2
    return 1
}

# --- Mode Aventure ---
mode_aventure() {
    if [ ! -f progression.txt ]; then echo 1 > progression.txt; fi
    local message="Choisissez un niveau (m=menu, h=home)."

    while true; do
        local niveau_atteint=$(<progression.txt)
        clear
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW}MODE AVENTURE${C_DEFAULT}"
        print_separator_line
        local progression_percent=$(( (niveau_atteint - 1) * 10 ))
        if [ "$progression_percent" -gt 100 ]; then progression_percent=100; fi
        print_centered_text "Progression: ${C_GREEN}${progression_percent}%${C_DEFAULT}"
        print_separator_line "─"

        for i in {1..10}; do
            local status_text color
            if [ "$i" -lt "$niveau_atteint" ]; then
                status_text="(Terminé ✔)"; color=$C_GREEN
            elif [ "$i" -eq "$niveau_atteint" ]; then
                status_text="(Jouable ▶)"; color=$C_YELLOW
            else
                status_text="(Verrouillé 🔒)"; color=$C_GRAY
            fi
            # Formatage corrigé pour ne pas dépasser la largeur de la boîte
            line=$(printf "%s Niveau %-2d  %-20s${C_DEFAULT}" "$color" "$i" "$status_text")
            print_left_aligned_text "$line"
        done
        
        print_separator_line
        print_centered_text "$message"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        
        read -p "Ton choix : " niveau_choisi

        case "$niveau_choisi" in
            [mM]) menu; return ;;
            [hH]) home_screen; return ;; 
            *)
                if ! [[ "$niveau_choisi" =~ ^[0-9]+$ ]] || [ "$niveau_choisi" -lt 1 ] || [ "$niveau_choisi" -gt "$niveau_atteint" ]; then
                    message="${C_RED}Choix invalide. Entrez un numéro de niveau jouable.${C_DEFAULT}"
                    continue
                elif [ "$niveau_choisi" -gt 10 ]; then
                    message="${C_YELLOW}Vous avez déjà terminé le jeu !${C_DEFAULT}"
                    continue
                else
                    break
                fi
                ;;
        esac
    done

    local total_score=0 rounds=3 objectif=999 max essais_max moyenne
    case $niveau_choisi in
        1) max=10; essais_max=6; moyenne=4 ;; 2) max=30; essais_max=7; moyenne=5 ;;
        3) max=50; essais_max=8; moyenne=6 ;; 4) max=70; essais_max=9; moyenne=7 ;;
        5) max=90; essais_max=10; moyenne=8 ;; 6) max=110; essais_max=11; moyenne=9 ;;
        7) max=130; essais_max=12; moyenne=10 ;; 8) max=150; essais_max=13; moyenne=11 ;;
        9) max=175; essais_max=14; moyenne=12 ;; 10) max=200; essais_max=15; moyenne=13 ;;
    esac

    for round in $(seq 1 $rounds); do
        jouer_niveau "$niveau_choisi" "$max" "$essais_max" "$moyenne" "$round" "$rounds"
        local ret=$?
        if [ $ret -eq 2 ]; then return; fi
        if [ $ret -eq 0 ]; then total_score=$(( total_score + score )); fi
        if [ "$round" -lt "$rounds" ] && [ $ret -ne 2 ]; then
            clear
            print_separator_line "═" "$BOX_TL" "$BOX_TR"
            print_centered_text "FIN DU ROUND $round"
            print_separator_line
            print_centered_text "Score total actuel : ${C_GREEN}$total_score / $objectif${C_DEFAULT}"
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 2
        fi
    done

    # --- Process level result (runs once) ---
    local result_message=""
    local unlock_message=""
    local success_message=""

    if [ "$total_score" -ge "$objectif" ]; then
        result_message="${C_GREEN}Félicitations ! Niveau terminé !${C_DEFAULT}"
        local niveau_atteint_actuel=$(<progression.txt)
        if [ "$niveau_choisi" -eq "$niveau_atteint_actuel" ]; then
            if [ "$niveau_choisi" -lt 10 ]; then
                local nouveau_niveau=$(( niveau_choisi + 1 ))
                echo "$nouveau_niveau" > progression.txt
                unlock_message="Niveau ${C_YELLOW}$nouveau_niveau${C_DEFAULT} débloqué !"
            elif [ "$niveau_choisi" -eq 10 ]; then
                echo 11 > progression.txt
                unlock_message="${C_GREEN}Vous avez terminé le Mode Aventure !${C_DEFAULT}"
                if ! grep -q "PLATINE" succes.txt 2>/dev/null; then
                    echo "PLATINE" >> succes.txt
                    success_message="🏆 ${C_YELLOW}SUCCÈS DÉBLOQUÉ : PLATINE${C_DEFAULT} 🏆"
                fi
            fi
        fi
    else
        result_message="${C_RED}Score insuffisant. Essayez encore !${C_DEFAULT}"
    fi

    # --- Display loop for user choice ---
    local error_message=""
    while true; do
        clear
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "FIN DU NIVEAU"
        print_separator_line
        print_centered_text "Score final : ${C_GREEN}$total_score / $objectif${C_DEFAULT}"
        print_separator_line
        
        print_centered_text "$result_message"
        if [ -n "$unlock_message" ]; then print_centered_text "$unlock_message"; fi
        if [ -n "$success_message" ]; then print_centered_text "$success_message"; fi
        
        print_separator_line
        print_centered_text "${C_GREEN}r: Rejouer / Autre niveau${C_DEFAULT} | ${C_YELLOW}m: Menu${C_DEFAULT} | ${C_BLUE}h: Home${C_DEFAULT}"
        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
        fi
        print_separator_line "═" "$BOX_BL" "$BOX_BR"

        read -p "Votre choix : " choix_fin
        
        case "$choix_fin" in
            r|R) mode_aventure; return ;;
            m|M) menu; return ;;
            h|H) home_screen; return ;;
            *) error_message="${C_RED}Entrée invalide. Merci de saisir r, m ou h.${C_DEFAULT}" ;;
        esac
    done
}

# --- Lancement du jeu ---
welcome_screen
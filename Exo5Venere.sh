 # --- Global Variables ---
# Couleurs
C_DEFAULT="\033[0m"
C_BLACK="\033[30m"
C_RED="\033[31m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_BLUE="\033[34m"
C_MAGENTA="\033[35m"
C_CYAN="\033[36m"
C_WHITE="\033[37m"

# God Mode
GOD_MODE=0
AIDE_ACTIVE=0
LANGUE="fr"

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
WIDTH=60



# --- Réinitialisation automatique à la sortie ---
# Si le script est quitté avec le God Mode activé, la progression est réinitialisée.
cleanup_on_exit() {
    if [ "$GOD_MODE" -eq 1 ]; then
        echo 1 > progression.txt
        rm -f succes.txt
    fi
}
trap cleanup_on_exit EXIT

toggle_god_mode() {
    if [ "$GOD_MODE" -eq 0 ]; then
        GOD_MODE=1
        echo 11 > progression.txt
        echo "PLATINE" > succes.txt
        clear
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW} G O D   M O D E ${C_DEFAULT}"
        print_centered_text "${C_GREEN}   A C T I V E D   ${C_DEFAULT}"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        sleep 2
    else
        GOD_MODE=0
        # Reset progress
        echo 1 > progression.txt
        rm -f succes.txt
        clear
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW} G O D   M O D E ${C_DEFAULT}"
        print_centered_text "${C_RED} D E S A C T I V E D ${C_DEFAULT}"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        sleep 2
    fi
}

# --- Fonctions d'affichage ---

# Affiche un bandeau si le God Mode est actif
display_god_mode_indicator() {
    if [ "$GOD_MODE" -eq 1 ]; then
        local text="${C_YELLOW} G O D   M O D E ${C_DEFAULT}"
        local visible_length
        visible_length=$(get_visible_length "$text")
        # On ajoute 2 pour la largeur des bordures ║ qui ne sont pas affichées ici
        local total_width=$((WIDTH + 2))
        local padding_total=$((total_width - visible_length))
        local padding_left=$((padding_total / 2))
        local padding_right=$((padding_total - padding_left))
        # On centre le texte sur la largeur totale de la boîte de dialogue
        printf "%*s%b%*s\n" "$padding_left" "" "$text" "$padding_right" ""
    else
        # Imprime une ligne vide pour conserver la hauteur et éviter les sauts d'affichage
        echo ""
    fi
}

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
  display_god_mode_indicator
  print_separator_line "═" "$BOX_TL" "$BOX_TR"
  print_centered_text "Bienvenue dans..."
  print_centered_text "ALEATORY NUMBER"
  print_separator_line
  print_left_aligned_text " Touche [${C_GREEN}Entrée${C_DEFAULT}] → START"
  print_left_aligned_text " Touche [${C_RED}e${C_DEFAULT}]      → EXIT"
  print_separator_line "═" "$BOX_BL" "$BOX_BR"
  echo ""

  read key

  if [[ "$key" == "gdmd" ]]; then
      toggle_god_mode
      home_screen
      return
  fi

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

choisir_langue() {
    local error_message=""
    while true; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "CHOIX DE LA LANGUE"
        print_separator_line

        local lang_fr="1 → Français (FR)"
        local lang_en="2 → English (EN)"
        local lang_es="3 → Español (ES)"

        if [ "$LANGUE" == "fr" ]; then
            lang_fr="${C_GREEN}${lang_fr} (Sélectionnée)${C_DEFAULT}"
        elif [ "$LANGUE" == "en" ]; then
            lang_en="${C_GREEN}${lang_en} (Selected)${C_DEFAULT}"
        elif [ "$LANGUE" == "es" ]; then
            lang_es="${C_GREEN}${lang_es} (Seleccionado)${C_DEFAULT}"
        fi

        print_left_aligned_text "$lang_fr"
        print_left_aligned_text "$lang_en"
        print_left_aligned_text "$lang_es"
        print_separator_line
        print_left_aligned_text "${C_RED}r → Retour${C_DEFAULT}"
        print_separator_line

        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            error_message=""
        else
            print_centered_text "Faites votre choix."
        fi
        
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        read -p "Votre choix : " choix

        case "$choix" in
            1)
                LANGUE="fr"
                clear
                print_separator_line "═" "$BOX_TL" "$BOX_TR"
                print_centered_text "${C_GREEN}Langue définie sur Français${C_DEFAULT}"
                print_separator_line "═" "$BOX_BL" "$BOX_BR"
                sleep 2
                return
                ;;
            2)
                LANGUE="en"
                clear
                print_separator_line "═" "$BOX_TL" "$BOX_TR"
                print_centered_text "${C_GREEN}Language set to English${C_DEFAULT}"
                print_separator_line "═" "$BOX_BL" "$BOX_BR"
                sleep 2
                return
                ;;
            3)
                LANGUE="es"
                clear
                print_separator_line "═" "$BOX_TL" "$BOX_TR"
                print_centered_text "${C_GREEN}Idioma establecido en Español${C_DEFAULT}"
                print_separator_line "═" "$BOX_BL" "$BOX_BR"
                sleep 2
                return
                ;;
            r|R)
                return
                ;;
            *)
                error_message="${C_RED}Choix invalide.${C_DEFAULT}"
                ;;
        esac
    done
}

# --- Home Screen ---
# Affiche le menu des paramètres
afficher_parametres() {
    local error_message=""
    while true; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "PARAMÈTRES"
        print_separator_line

        local aide_status
        if [ "$AIDE_ACTIVE" -eq 1 ]; then
            aide_status="${C_GREEN}(Activée)${C_DEFAULT}"
        else
            aide_status="${C_RED}(Désactivée)${C_DEFAULT}"
        fi

        print_left_aligned_text "${C_YELLOW}1 → Activer/Désactiver l'aide${C_DEFAULT} ${aide_status}"
        print_left_aligned_text "${C_GREEN}2 → Changer la langue${C_DEFAULT}"
        print_left_aligned_text "${C_RED}3 → Retour${C_DEFAULT}"
        print_separator_line
        
        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            if [ "$GOD_MODE" -eq 1 ]; then
                print_centered_text "${C_YELLOW}Ψ Oracle Ψ : Le nombre est ${nombre}${C_DEFAULT}"
            fi
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi

        print_centered_text "Faites votre choix."
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        read -p "Votre choix : " choix

        case "$choix" in
            1)
                if [ "$AIDE_ACTIVE" -eq 0 ]; then
                    AIDE_ACTIVE=1
                    message="Aide ${C_GREEN}ACTIVÉE${C_DEFAULT}"
                else
                    AIDE_ACTIVE=0
                    message="Aide ${C_RED}DÉSACTIVÉE${C_DEFAULT}"
                fi
                clear
                print_separator_line "═" "$BOX_TL" "$BOX_TR"
                print_centered_text "$message"
                print_separator_line "═" "$BOX_BL" "$BOX_BR"
                sleep 2
                ;;
            2)
                choisir_langue
                ;;
            3)
                return
                ;;
            *)
                error_message="${C_RED}Choix invalide.${C_DEFAULT}"
                ;;
        esac
    done
}

home_screen() {
  local error_message=""
  while true; do
    clear
    display_god_mode_indicator
    print_separator_line "═" "$BOX_TL" "$BOX_TR"
    print_centered_text "ALEATORY NUMBER"
    print_separator_line
    print_left_aligned_text "${C_GREEN}1 → Nouvelle Partie${C_DEFAULT}"
    print_left_aligned_text "${C_YELLOW}2 → Continuer${C_DEFAULT}"
    print_left_aligned_text "${C_RED}3 → Quitter${C_DEFAULT}"
    print_left_aligned_text "${C_CYAN}4 → Paramètres${C_DEFAULT}"
    print_separator_line
    if [ -n "$error_message" ]; then
        print_centered_text "$error_message"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        sleep 1
        error_message=""
        continue
    fi
    print_centered_text "Faites votre choix."
    print_separator_line "═" "$BOX_BL" "$BOX_BR"

    read -p "Votre choix : " choix
    if [[ "$choix" == "gdmd" ]]; then
        toggle_god_mode
        error_message=""
        continue
    fi

    case "$choix" in
      1) # Nouvelle partie
        local confirm_error=""
        while true; do
            clear
            display_god_mode_indicator
            print_separator_line "═" "$BOX_TL" "$BOX_TR"
            print_centered_text "${C_YELLOW}RÉINITIALISER ?${C_DEFAULT}"
            print_separator_line
            print_centered_text "Cela effacera votre progression."
            print_centered_text "Êtes-vous sûr ?"
            print_separator_line
            print_centered_text "${C_GREEN}o: Oui${C_DEFAULT}  |  ${C_RED}n: Non${C_DEFAULT}"
            if [ -n "$confirm_error" ]; then
                print_centered_text "$confirm_error"
                print_separator_line "═" "$BOX_BL" "$BOX_BR"
                sleep 1
                confirm_error=""
                continue
            fi
            print_separator_line "═" "$BOX_BL" "$BOX_BR"

            read -p "Votre choix : " confirmation
            case "$confirmation" in
                [oO]|oui)
                    rm -f progression.txt succes.txt
                    echo 1 > progression.txt
                    if [ "$GOD_MODE" -eq 1 ]; then
                        echo 11 > progression.txt
                        echo "PLATINE" > succes.txt
                    fi
                    menu # Go to menu after reset
                    return
                    ;;
                [nN]|non)
                    home_screen # Go back to home
                    return
                    ;;
                *)
                    confirm_error="${C_RED}Réponse invalide.${C_DEFAULT}"
                    ;;
            esac
        done
        ;;
      2) # Continuer
        if [ ! -f progression.txt ]; then echo 1 > progression.txt; fi
        menu
        return
        ;;
      3) # Quitter
        clear
        echo "Merci d'avoir joué ! À bientôt !"
        exit 0
        ;;
      4) # Paramètres
        afficher_parametres
        ;;
      *)
        error_message="${C_RED}Choix invalide. Merci de saisir 1, 2, 3 ou 4.${C_DEFAULT}"
        ;;
    esac
  done
}

# --- Menu Principal ---
menu() {
  local error_message=""
  while true; do
    clear
    display_god_mode_indicator
    print_separator_line "═" "$BOX_TL" "$BOX_TR"
    print_centered_text "MENU PRINCIPAL"
    print_separator_line
    print_left_aligned_text "${C_GREEN}1 → Mode Libre${C_DEFAULT}"
    if { [ "$GOD_MODE" -eq 1 ] || { [ -f succes.txt ] && grep -q "PLATINE" succes.txt; }; }; then
      print_left_aligned_text "${C_YELLOW}2 → Mode Aventure (Platiné)${C_DEFAULT}"
    else
      print_left_aligned_text "${C_YELLOW}2 → Mode Aventure${C_DEFAULT}"
    fi
    print_left_aligned_text "${C_RED}3 → Retour${C_DEFAULT}"
    print_separator_line
    if [ -n "$error_message" ]; then
        print_centered_text "$error_message"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        sleep 1
        error_message=""
        continue
    fi
    print_centered_text "Faites votre choix."
    print_separator_line "═" "$BOX_BL" "$BOX_BR"

    read -p "Votre choix : " mode
    if [[ "$mode" == "gdmd" ]]; then
        toggle_god_mode
        error_message=""
        continue
    fi
    case "$mode" in
      1) mode_libre; return ;;
      2) mode_aventure; return ;;
      3) home_screen; return ;;
      *) error_message="${C_RED}Choix invalide. Merci de saisir 1, 2 ou 3.${C_DEFAULT}" ;;
    esac
  done
}

# --- Mode Libre ---
mode_libre() {
    # --- Définition des niveaux de difficulté ---
    local difficultes_noms=("Très Facile" "Facile" "Moyen" "Difficile" "Expert" "Légendaire" "Divin")
    local difficultes_max=(10 50 100 250 500 1000 2000)
    local difficultes_couleurs=("${C_GREEN}" "${C_GREEN}" "${C_YELLOW}" "${C_RED}" "${C_BLUE}" "${C_CYAN}" "${C_PURPLE}")

    # --- Boucle pour choisir la difficulté ---
    local choix_diff
    local error_message=""
    while true; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW}M O D E   L I B R E${C_DEFAULT}"
        print_separator_line
        print_centered_text "Choisissez une difficulté :"
        print_separator_line
        for i in "${!difficultes_noms[@]}"; do
            local num=$((i + 1))
            local nom=${difficultes_noms[$i]}
            local max=${difficultes_max[$i]}
            local couleur=${difficultes_couleurs[$i]}
            print_left_aligned_text "  $num: ${couleur}${nom}${C_DEFAULT} (1-$max)"
        done
        print_separator_line
        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi
        print_centered_text "Entrez un chiffre de 1 à ${#difficultes_noms[@]}."
        print_separator_line "═" "$BOX_BL" "$BOX_BR"

        read -p "Votre choix : " choix_diff
        if [[ "$choix_diff" =~ ^[1-7]$ ]] && [ "$choix_diff" -le "${#difficultes_noms[@]}" ]; then
            break
        else
            error_message="${C_RED}Difficulté invalide.${C_DEFAULT}"
        fi
    done

    local max=${difficultes_max[$((choix_diff - 1))]}
    local nombre=$(( (RANDOM % max) + 1 ))
    local borne_min=1
    local borne_max=$max

    # Calcul du nombre d'essais max via la dichotomie (avec plafond) + 2
    local essais_necessaires=$(awk -v n="$max" 'BEGIN{l=log(n)/log(2); print (l == int(l)) ? l : int(l)+1}')
    local essais_max=$((essais_necessaires + 2))

    local compteur=0
    local propositions=()
    local reponse
    local message="Faites votre proposition."
    error_message="" # On réutilise la variable, mais on la vide pour la boucle de jeu.

    while [ "$compteur" -lt "$essais_max" ]; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW}MODE LIBRE${C_DEFAULT}"
        print_separator_line
        local essais_restants=$((essais_max - compteur))
        print_centered_text "Il vous reste ${C_YELLOW}$essais_restants/${essais_max}${C_DEFAULT} essais."
        if [ "$borne_min" -eq "$borne_max" ]; then
            print_centered_text "Le nombre est ${C_YELLOW}$borne_min${C_DEFAULT}."
        else
            print_centered_text "Le nombre est entre ${C_YELLOW}$borne_min${C_DEFAULT} et ${C_YELLOW}$borne_max${C_DEFAULT}."
        fi
        if [ ${#propositions[@]} -gt 0 ]; then
            local unique_propositions="${propositions[*]}"
            print_centered_text "Vos essais: ${C_WHITE}${unique_propositions}${C_DEFAULT}"
        else
            print_centered_text " "
        fi
        print_separator_line

        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            if [ "$GOD_MODE" -eq 1 ]; then
                print_centered_text "${C_YELLOW}Ψ Oracle Ψ : Le nombre est ${nombre}${C_DEFAULT}"
            fi
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi

        print_centered_text "$message"
        if [ "$GOD_MODE" -eq 1 ]; then
            print_centered_text "${C_YELLOW}Ψ Oracle Ψ : Le nombre est ${nombre}${C_DEFAULT}"
        fi
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        
        read -p "Votre proposition (m=menu, h=home) : " reponse

        if [[ "$reponse" == "gdmd" ]]; then
            toggle_god_mode
            continue
        fi

        if [[ "$reponse" =~ ^[mMhH]$ ]]; then
            case "$reponse" in m|M) menu; return ;; h|H) home_screen; return ;; esac
        elif ! [[ "$reponse" =~ ^[0-9]+$ ]] || [ "$reponse" -lt "$borne_min" ] || [ "$reponse" -gt "$borne_max" ]; then
            error_message="${C_RED}Entrée invalide. Un nombre entre $borne_min et $borne_max est attendu.${C_DEFAULT}"
            continue
        fi

        propositions+=("$reponse")
        compteur=$((compteur + 1))

        if [ "$reponse" -eq "$nombre" ]; then
            message="${C_GREEN}🎉 GAGNÉ ! Vous avez trouvé ${nombre} en ${compteur} essais. 🎉${C_DEFAULT}"
            break # Sortir de la boucle de jeu
        elif [ "$reponse" -lt "$nombre" ]; then
            message="Le nombre mystère est ${C_YELLOW}PLUS GRAND${C_DEFAULT} !"
            if [ "$AIDE_ACTIVE" -eq 1 ]; then
                borne_min=$((reponse + 1))
            fi
        else
            message="Le nombre mystère est ${C_YELLOW}PLUS PETIT${C_DEFAULT} !"
            if [ "$AIDE_ACTIVE" -eq 1 ]; then
                borne_max=$((reponse - 1))
            fi
        fi
    done

    # Si le joueur n'a pas trouvé le nombre à temps, mettre à jour le message
    if [ "$compteur" -ge "$essais_max" ] && [ "$reponse" -ne "$nombre" ]; then
        message="${C_RED}PERDU. Le nombre était ${nombre}.${C_DEFAULT}"
    fi

    # Boucle de fin de partie pour rejouer ou quitter
    local choix_fin
    local error_message_fin=""
    while true; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "FIN DE LA PARTIE"
        print_separator_line
        print_centered_text "$message"
        print_separator_line

        if [ -n "$error_message_fin" ]; then
            print_centered_text "$error_message_fin"
        else
            print_centered_text "${C_GREEN}r: Rejouer${C_DEFAULT} | ${C_YELLOW}m: Menu${C_DEFAULT} | ${C_BLUE}h: Home${C_DEFAULT}"
        fi
        
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        read -p "Votre choix : " choix_fin

        if [ -n "$error_message_fin" ]; then
            sleep 1
            error_message_fin=""
        fi

        if [[ "$choix_fin" == "gdmd" ]]; then
            toggle_god_mode
            continue
        fi

        case "$choix_fin" in
            r|R) mode_libre; return ;; # Relance une nouvelle partie libre
            m|M) menu; return ;;       # Retourne au menu de sélection des modes
            h|H) home_screen; return ;; # Retourne à l'écran d'accueil
            *) error_message_fin="${C_RED}Choix invalide.${C_DEFAULT}" ;;
        esac
    done
}

# --- Fonction jouer_niveau (Aventure) ---
jouer_niveau() {
    local niveau=$1 max=$2 _essais_max_old=$3 _moyenne_old=$4 round_num=$5 total_rounds=$6
    local borne_min=1
    local borne_max=$max

    # Nouvelle logique de calcul des essais
    local essais_dichotomie
    essais_dichotomie=$(echo "a=l($max)/l(2); scale=0; if(a%1>0) a/1+1 else a/1" | bc -l 2>/dev/null)
    if ! [[ "$essais_dichotomie" =~ ^[0-9]+$ ]] || [ "$essais_dichotomie" -eq 0 ]; then # Fallback
        local val=1
        local count=0
        while [ "$val" -lt "$max" ]; do
            val=$((val * 2))
            count=$((count + 1))
        done
        essais_dichotomie=$count
        if [ "$essais_dichotomie" -eq 0 ]; then essais_dichotomie=1; fi
    fi

    local essais_max=$((essais_dichotomie + 2))
    local nombre=$(( (RANDOM % max) + 1 ))
    local compteur=0
    local propositions=()
    local reponse
    local message="Faites votre proposition."
    local error_message=""

    while [ "$compteur" -lt "$essais_max" ]; do
        clear
        display_god_mode_indicator
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "${C_YELLOW}NIVEAU $niveau ${C_CYAN}- ROUND $round_num/$total_rounds${C_DEFAULT}"
        print_separator_line
        local essais_restants=$((essais_max - compteur))
        print_centered_text "Il vous reste ${C_WHITE}$essais_restants/${essais_max}${C_DEFAULT} essais."
        if [ "$borne_min" -eq "$borne_max" ]; then
            print_centered_text "Le nombre est ${C_YELLOW}$borne_min${C_DEFAULT}."
        else
            print_centered_text "Le nombre est entre ${C_YELLOW}$borne_min${C_DEFAULT} et ${C_YELLOW}$borne_max${C_DEFAULT}."
        fi
        if [ ${#propositions[@]} -gt 0 ]; then
            local unique_propositions="${propositions[*]}"
            print_centered_text "Vos essais: ${C_CYAN}${unique_propositions}${C_DEFAULT}"
        else
            print_centered_text " "
        fi
        print_separator_line

        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            if [ "$GOD_MODE" -eq 1 ]; then
                print_centered_text "${C_YELLOW}Ψ Oracle Ψ : Le nombre est ${nombre}${C_DEFAULT}"
            fi
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi

        print_centered_text "$message"
        if [ "$GOD_MODE" -eq 1 ]; then
            print_centered_text "${C_YELLOW}Ψ Oracle Ψ : Le nombre est ${nombre}${C_DEFAULT}"
        fi
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        
        read -p "Votre proposition (m=menu, h=home) : " reponse

        if [[ "$reponse" == "gdmd" ]]; then
            toggle_god_mode
            continue
        fi

        if [[ "$reponse" =~ ^[mMhH]$ ]]; then
            case "$reponse" in m|M) menu; exit 2 ;; h|H) home_screen; exit 2 ;; esac
        elif ! [[ "$reponse" =~ ^[0-9]+$ ]] || [ "$reponse" -lt "$borne_min" ] || [ "$reponse" -gt "$borne_max" ]; then
            error_message="${C_RED}Entrée invalide. Un nombre entre $borne_min et $borne_max est attendu.${C_DEFAULT}"
            continue
        fi

        propositions+=("$reponse")
        compteur=$((compteur + 1))

        if [ "$reponse" -eq "$nombre" ]; then
            local k=0
            if [ "$essais_dichotomie" -gt 1 ]; then
                k=$(( 100 / (essais_dichotomie - 1) ))
            else
                k=100
            fi
            score=$(( 333 + k * (essais_dichotomie - compteur) ))
            if [ $score -lt 0 ]; then score=0; fi

            clear
            display_god_mode_indicator
            print_separator_line "═" "$BOX_TL" "$BOX_TR"
            print_centered_text "${C_GREEN}🎉 ROUND GAGNÉ ! 🎉${C_DEFAULT}"
            print_separator_line
            print_centered_text "Vous avez trouvé ${C_YELLOW}$nombre${C_DEFAULT} en ${C_YELLOW}$compteur${C_DEFAULT} essais !"
            print_centered_text "L'objectif était de le trouver en ${C_YELLOW}$essais_dichotomie${C_DEFAULT} essais."
            print_centered_text "Vous marquez ${C_GREEN}$score${C_DEFAULT} points."
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 2
            return 0
        elif [ "$reponse" -lt "$nombre" ]; then
            message="Le nombre mystère est ${C_YELLOW}PLUS GRAND${C_DEFAULT} !"
            if [ "$AIDE_ACTIVE" -eq 1 ]; then
                borne_min=$((reponse + 1))
            fi
        else
            message="Le nombre mystère est ${C_YELLOW}PLUS PETIT${C_DEFAULT} !"
            if [ "$AIDE_ACTIVE" -eq 1 ]; then
                borne_max=$((reponse - 1))
            fi
        fi
    done

    clear
    display_god_mode_indicator
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
    local error_message=""

    local niveau_choisi
    while true; do
        local niveau_atteint
        if [ "$GOD_MODE" -eq 1 ]; then
            niveau_atteint=11
        else
            niveau_atteint=$(<progression.txt)
        fi
        
        clear
        display_god_mode_indicator
        
        local adventure_title="${C_YELLOW}M O D E   A V E N T U R E${C_DEFAULT}"
        if { [ "$GOD_MODE" -eq 1 ] || { [ -f succes.txt ] && grep -q "PLATINE" succes.txt; }; }; then
            adventure_title="${C_YELLOW}AVENTURE (Platiné)${C_DEFAULT}"
        fi
        
        print_separator_line "═" "$BOX_TL" "$BOX_TR"
        print_centered_text "$adventure_title"
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
            line=$(printf "%s Niveau %-2d  %-20s${C_DEFAULT}" "$color" "$i" "$status_text")
            print_left_aligned_text "$line"
        done
        
        print_separator_line
        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi

        print_centered_text "Choisissez un niveau jouable."
        print_centered_text "${C_YELLOW}m: Menu${C_DEFAULT} | ${C_BLUE}h: Home${C_DEFAULT}"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"
        
        read -p "Votre choix : " niveau_choisi

        if [[ "$niveau_choisi" == "gdmd" ]]; then
            toggle_god_mode
            error_message="" # Reset error message
            continue
        fi

        case "$niveau_choisi" in
            [mM]) menu; return ;; 
            [hH]) home_screen; return ;; 
            *)
                if ! [[ "$niveau_choisi" =~ ^[0-9]+$ ]]; then
                    error_message="${C_RED}Entrée invalide. Saisissez un nombre.${C_DEFAULT}"
                    continue
                fi

                if [ "$GOD_MODE" -eq 0 ] && [ "$niveau_choisi" -gt "$niveau_atteint" ]; then
                     error_message="${C_RED}Niveau $niveau_choisi non débloqué.${C_DEFAULT}"
                     continue
                fi

                if [ "$niveau_choisi" -gt 10 ]; then
                    if [ "$GOD_MODE" -eq 1 ]; then
                        # Allow replaying level 10 in God Mode
                        niveau_choisi=10
                    else
                        error_message="${C_YELLOW}Vous avez déjà terminé le jeu !${C_DEFAULT}"
                        continue
                    fi
                fi
                # Valid choice, break the loop
                break
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
            display_god_mode_indicator
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
                if grep -q "PLATINE" succes.txt 2>/dev/null; then
                    unlock_message="${C_GREEN}Vous avez terminé le Mode Aventure (Platiné) !${C_DEFAULT}"
                fi
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
        if [ -n "$error_message" ]; then
            print_centered_text "$error_message"
            print_separator_line "═" "$BOX_BL" "$BOX_BR"
            sleep 1
            error_message=""
            continue
        fi

        print_centered_text "${C_GREEN}r: Rejouer / Autre niveau${C_DEFAULT} | ${C_YELLOW}m: Menu${C_DEFAULT} | ${C_BLUE}h: Home${C_DEFAULT}"
        print_separator_line "═" "$BOX_BL" "$BOX_BR"

        read -p "Votre choix : " choix_fin

        if [[ "$choix_fin" == "gdmd" ]]; then
            toggle_god_mode
            continue
        fi
                
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
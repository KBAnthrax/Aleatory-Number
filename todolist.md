# todolist

## Bugs 
- [ ] Reregarder dans le tout premier chat les points à améliorer
- [ ] Trouver d'autres moyens fun de jouer
- [ ] Trouver une solution pour pb de cadrage
- [ ] Ajouter les langues Anglais, Espagnol et Français 



Peux tu reformuler ca pour demander à une IA de m’aider à coder un jeu en Bash dans lequel l’utilisateur doit deviner un nombre aléatoire compris entre deux bornes définies:
""
## Idées d'améliorations pour `Exo5Venere.sh`

### Graphisme / UX
-1 [ ] Ajouter des illustrations ASCII animées pour l’écran titre ou la fin de niveau.
-2 [ ] Palette de thèmes (dark, light, matrix) modifiant les couleurs ANSI.
-3 [ ] Effets sonores simples (bip ou lecture d’un fichier `.wav`) lors de la victoire/défaite.
-4 [ ] Barre de progression colorée représentant les essais restants.
-5 [ ] Menus basés sur `dialog` / `whiptail` pour une navigation plus visuelle.

### Fonctionnalités de jeu
-6 [ ] Défi quotidien : nombre généré à partir de la date + classement des meilleurs scores.
-7 [ ] Faie un profil de joueur avec pseudo et titres de succès.
-8 [ ] Succès supplémentaires :  « Sniper » (trouver du premier coup 3 niveaux d’affilée).
-9 [ ] Multijoueur asynchrone : partage d’un *seed* et du score pour défier ses amis.
-10 [ ] Mode « Endless » avec difficulté croissante après le niveau 10.

### Utilitaires & Qualité de vie
-11 [ ] Fichier de configuration `~/.exo5rc` (langue, couleurs, son ON/OFF).
-12 [ ] Autocomplétion Bash pour les options du script.
-13 [ ] Option `--help` et page *man* détaillée.
-14 [ ] Historique des parties `~/.exo5_history` (date, niveau, score).
-15 [ ] Tests unitaires avec `bats-core` pour fiabiliser la logique de devinette.

██              █████████  ██████████ ██████   ██████ █████ ██████   █████ █████
░░░███         ███░░░░░███░░███░░░░░█░░██████ ██████ ░░███ ░░██████ ░░███ ░░███
  ░░░███      ███     ░░░  ░███  █ ░  ░███░█████░███  ░███  ░███░███ ░███  ░███
    ░░░███   ░███          ░██████    ░███░░███ ░███  ░███  ░███░░███░███  ░███
     ███░    ░███    █████ ░███░░█    ░███ ░░░  ░███  ░███  ░███ ░░██████  ░███
   ███░      ░░███  ░░███  ░███ ░   █ ░███      ░███  ░███  ░███  ░░█████  ░███
 ███░         ░░█████████  ██████████ █████     █████ █████ █████  ░░█████ █████
░░░            ░░░░░░░░░  ░░░░░░░░░░ ░░░░░     ░░░░░ ░░░░░ ░░░░░    ░░░░░ ░░░░░
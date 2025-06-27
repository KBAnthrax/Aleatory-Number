# Website TODO – Portage du jeu Bash `Exo5Venere.sh` vers un site statique

Coche les cases au fur et à mesure de l’avancement.

## 1. Initialisation du projet
- [x] Créer le répertoire `web/` (ou à la racine, selon préférence) pour contenir le site
- [x] À l’intérieur, ajouter la structure de base :
  - [x] `index.html`
  - [x] `js/` – scripts JavaScript
  - [x] `css/` – fichiers CSS personnalisés (optionnel avec Bootstrap)
  - [x] `assets/` – images, sons, polices, etc.
- [x] Ajouter Bootstrap 5 via CDN dans `index.html`

## 2. Portage de la logique du jeu
- [x] Analyser le script `Exo5Venere.sh` et repérer :
  - [x] Les variables d’état principales du jeu
  - [x] Les fonctions/étapes clés (initialisation, tour de jeu, gestion des entrées, conditions de victoire/défaite)
- [x] Créer `js/game.js` et y définir :
  - [x] Les structures de données équivalentes (objets, tableaux, constantes)
  - [x] Les fonctions principales : `initGame()`, `playTurn()`, `handleInput()`, `checkEndGame()`
  - [x] Un point d’entrée `startGame()` qu’on appellera depuis l’UI

## 3. Interface Utilisateur
- [x] Maquette rapide (papier/Figma) de l’UI : zones d’affichage, boutons, messages
- [x] Dans `index.html` :
  - [x] Container Bootstrap (`<div class="container">`)
  - [x] En-tête/Titre du jeu
  - [x] Div pour le plateau/affichage du jeu
  - [x] Div pour les stats (score, vies, etc.)
  - [x] Boutons d’action (Nouvelle partie, Recommencer, etc.)
- [x] Styliser au besoin dans `css/styles.css`

## 4. Gestion des entrées & interactions
- [x] Ajouter les écouteurs d’évènements sur les boutons
- [x] (Si pertinent) Ajouter la capture du clavier pour les actions rapides
- [x] Connecter les entrées à `handleInput()`

## 5. Boucle de jeu & rendu
- [x] Mettre en place une boucle (ou appels successifs) pour actualiser l’état du jeu
- [x] Mettre à jour le DOM pour refléter l’état après chaque tour
- [x] Gérer les animations/transitions CSS si souhaité

## 6. Écrans de fin & redémarrage
- [x] Détecter victoire/défaite via `checkEndGame()`
- [x] Afficher un écran/overlay de fin avec score et options (Rejouer, Quitter)

## 7. Persistance facultative
- [ ] Sauvegarder les meilleurs scores dans `localStorage`
- [ ] Charger les scores au démarrage et les afficher dans un tableau

## 8. Responsive & accessibilité
- [ ] Tester l’UI sur tailles mobile/tablette/desktop
- [ ] Ajuster la grille Bootstrap et les classes utilitaires
- [ ] Vérifier le contraste, l’accessibilité (aria-labels, focus management)

## 9. Tests & débogage
- [ ] Tester toutes les branches de logic
- [ ] Vérifier qu’aucune erreur ne s’affiche dans la console du navigateur
- [ ] Ajouter des logs ou assertions si nécessaire

## 10. Packaging & déploiement
- [ ] Générer une version minifiée/optimisée (optionnel)
- [ ] Tester le site via un serveur local (`npx serve` ou équivalent)
- [ ] Publier sur GitHub Pages / GitLab Pages / Netlify

## 11. Documentation
- [ ] Ajouter un fichier `README.md` décrivant :
  - [ ] Le but du projet
  - [ ] Comment l’exécuter localement (ouvrir `index.html` ou lancer un serveur)
  - [ ] Technologies utilisées (HTML, CSS + Bootstrap, JavaScript vanilla)
  - [ ] Auteur & licence

---

Une fois toutes ces étapes terminées, le jeu Bash sera entièrement porté sur un site statique moderne et facilement partageable.

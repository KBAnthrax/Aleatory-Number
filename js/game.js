// ===================================
//  CONFIG & CONSTANTES
// ===================================

const CONFIG = {
    adventureLevels: [
        { max: 10, rounds: 3 },
        { max: 25, rounds: 3 },
        { max: 50, rounds: 3 },
        { max: 100, rounds: 4 },
        { max: 250, rounds: 4 },
        { max: 500, rounds: 4 },
        { max: 750, rounds: 5 },
        { max: 1000, rounds: 5 },
        { max: 1500, rounds: 5 },
        { max: 2000, rounds: 5 },
    ],
    freeModeDifficulties: {
        'Très Facile': 10,
        'Facile': 50,
        'Moyen': 100,
        'Difficile': 250,
        'Expert': 500,
        'Légendaire': 1000,
        'Divin': 2000,
    },
    godModeKey: 'gdmd'
};

// ===================================
//  TRADUCTIONS (i18n)
// ===================================

const i18n = {
    fr: {
        welcome: "Bienvenue dans Vénère !",
        guessTheNumber: "Devinez le nombre entre 1 et {max} !",
        freeMode: "Mode Libre",
        adventureMode: "Mode Aventure",
        level: "Niveau",
        guessLabel: "Proposition :",
        win: "Bravo ! Vous avez trouvé en {attempts} tentatives.",
        winTitle: "Gagné !",
        lose: "Perdu... Le nombre était {secret}.",
        loseTitle: "Dommage !",
        tooLow: "C'est plus",
        tooHigh: "C'est moins",
        gameOver: "Partie terminée."
    },
    en: {
        welcome: "Welcome to Vénère!",
        guessTheNumber: "Guess the number between 1 and {max}!",
        freeMode: "Free Mode",
        adventureMode: "Adventure Mode",
        level: "Level",
        guessLabel: "Guess:",
        win: "Congratulations! You found it in {attempts} tries.",
        winTitle: "You Won!",
        lose: "You lost... The number was {secret}.",
        loseTitle: "Too Bad!",
        tooLow: "It's higher",
        tooHigh: "It's lower",
        gameOver: "Game Over."
    },
    es: {
        welcome: "¡Bienvenido a Vénère!",
        guessTheNumber: "¡Adivina el número entre 1 y {max}!",
        freeMode: "Modo Libre",
        adventureMode: "Modo Aventura",
        level: "Nivel",
        guessLabel: "Propuesta:",
        win: "¡Felicidades! Lo encontraste en {attempts} intentos.",
        winTitle: "¡Ganaste!",
        lose: "Perdiste... El número era {secret}.",
        loseTitle: "¡Qué Lástima!",
        tooLow: "Es más alto",
        tooHigh: "Es más bajo",
        gameOver: "Juego Terminado."
    }
};


// ===================================
//  ÉTAT DU JEU (GAME STATE)
// ===================================

let gameState = {
    godMode: false,
    language: 'fr',
    helpActive: false,
    currentMode: null, // 'adventure' or 'free'
    currentLevel: 0,
    currentRound: 0,
    score: 0,
    lives: 0,
    secretNumber: 0,
    minBound: 1,
    maxBound: 100,
    guesses: [],
    adventureProgress: 1 // Niveau max débloqué
};

// ===================================
//  FONCTIONS PRINCIPALES
// ===================================

// ===================================
//  ÉLÉMENTS DU DOM
// ===================================

const dom = {
    containers: {
        freeModeDifficultySelect: document.getElementById('free-mode-difficulty-select'),
        adventureLevelSelect: document.getElementById('adventure-level-select'),
    },
    screens: {
        home: document.getElementById('home-screen'),
        modeSelect: document.getElementById('mode-select-screen'),
        adventure: document.getElementById('adventure-screen'),
        freeMode: document.getElementById('free-mode-screen'),
        game: document.getElementById('game-screen'),
        settings: document.getElementById('settings-screen'),
        endGame: document.getElementById('end-game-screen'),
    },
    buttons: {
        newGame: document.getElementById('new-game-btn'),
        continue: document.getElementById('continue-btn'),
        settings: document.getElementById('settings-btn'),
        adventureMode: document.getElementById('adventure-mode-btn'),
        freeMode: document.getElementById('free-mode-btn'),
        backToHome: document.querySelectorAll('.back-to-home-btn'),
        guess: document.getElementById('guess-btn'),
        playAgain: document.getElementById('play-again-btn'),
    },
    inputs: {
        guess: document.getElementById('guess-input'),
    },
    elements: {
        game: {
            title: document.getElementById('game-title'),
            message: document.getElementById('game-message'),
            attempts: document.getElementById('attempts-count'),
            previousGuesses: document.getElementById('previous-guesses-list'),
        },
        endGame: {
            title: document.getElementById('end-game-title'),
            message: document.getElementById('end-game-message'),
        }
    },
    godModeIndicator: document.getElementById('god-mode-indicator'),
};

// ===================================
//  FONCTIONS D'UI
// ===================================

/**
 * Affiche un écran spécifique et cache les autres.
 * @param {string} screenId L'ID de l'écran à afficher (sans le '-screen').
 */
function showScreen(screenName) {
    Object.values(dom.screens).forEach(screen => {
        if(screen) screen.classList.remove('active');
    });
    if (dom.screens[screenName]) {
        dom.screens[screenName].classList.add('active');
    } else {
        console.error(`L'écran '${screenName}' n'existe pas.`);
    }
}

/**
 * Initialise le jeu au chargement de la page.
 */
function initGame() {
    console.log("Initialisation du jeu...");
    loadProgress();
    showScreen('home'); // Afficher l'écran d'accueil
    setupEventListeners(); 
}

/**
 * Met en place tous les écouteurs d'événements pour l'UI.
 */
function setupEventListeners() {
    // --- Navigation principale ---
    dom.buttons.newGame.addEventListener('click', () => showScreen('modeSelect'));
    dom.buttons.settings.addEventListener('click', () => showScreen('settings'));
    dom.buttons.continue.addEventListener('click', () => {
        // TODO: Remplir l'écran aventure avec les niveaux
        showScreen('adventure');
    });
    dom.buttons.backToHome.forEach(btn => {
        btn.addEventListener('click', () => showScreen('home'));
    });

    // --- Sélection du mode de jeu ---
    dom.buttons.adventureMode.addEventListener('click', () => {
        // TODO: Remplir l'écran aventure avec les niveaux
        showScreen('adventure');
    });
    dom.buttons.freeMode.addEventListener('click', () => {
        populateFreeModeScreen();
        showScreen('freeMode');
    });

    dom.buttons.playAgain.addEventListener('click', () => {
        // Relance une partie avec les mêmes paramètres
        startGame(gameState.mode, gameState.difficulty);
    });

    // --- Écran de jeu ---
    dom.buttons.guess.addEventListener('click', () => {
        const value = dom.inputs.guess.value;
        if (value) {
            handleGuess(parseInt(value, 10));
            dom.inputs.guess.value = '';
            dom.inputs.guess.focus();
        }
    });

    dom.inputs.guess.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            dom.buttons.guess.click();
        }
    });

    // TODO: Ajouter les listeners pour les paramètres (langue, aide)
}

/**
 * Remplit l'écran de sélection du mode libre avec les boutons de difficulté.
 */
function populateFreeModeScreen() {
    const container = dom.containers.freeModeDifficultySelect;
    container.innerHTML = ''; // Vider les anciens boutons
    Object.keys(CONFIG.freeModeDifficulties).forEach(difficulty => {
        const btn = document.createElement('button');
        btn.className = 'btn btn-outline-primary m-2';
        btn.textContent = `${difficulty} (1-${CONFIG.freeModeDifficulties[difficulty]})`;
        btn.addEventListener('click', () => {
            startGame('free', { name: difficulty, max: CONFIG.freeModeDifficulties[difficulty] });
        });
        container.appendChild(btn);
    });
}

/**
 * Démarre une nouvelle partie (Aventure ou Libre).
 */
function startGame(mode, config) {
    gameState.mode = mode;
    gameState.difficulty = config;
    gameState.secretNumber = Math.floor(Math.random() * config.max) + 1;
    gameState.maxAttempts = Math.floor(Math.log2(config.max)) + 2; // Calcul dynamique des essais max
    gameState.attempts = 0;
    gameState.previousGuesses = [];
    gameState.isGameOver = false;
    gameState.message = i18n[gameState.language].guessTheNumber.replace('{max}', config.max);

    if (gameState.godMode) {
        console.log(`GOD MODE: Le nombre secret est ${gameState.secretNumber}`);
        gameState.message += ` (Pssst, c'est ${gameState.secretNumber})`;
    }

    updateDisplay();
    showScreen('game');
}

/**
 * Gère la soumission d'une proposition par le joueur.
 */
function handleGuess(guess) {
    if (gameState.isGameOver) return;

    gameState.attempts++;
    gameState.previousGuesses.push(guess);

    // Mettre à jour l'affichage pour que le joueur voie sa dernière tentative
    updateDisplay(); 

    // Vérifier si la partie est terminée
    checkEndGame(guess);
}

/**
 * Vérifie les conditions de victoire ou de défaite.
 */
function checkEndGame(guess) {
    const isWin = (guess === gameState.secretNumber);
    const isLoss = (gameState.attempts >= gameState.maxAttempts);

    if (isWin) {
        gameState.isGameOver = true;
        showEndGameScreen(true);
    } else if (isLoss) {
        gameState.isGameOver = true;
        showEndGameScreen(false);
    } else {
        // La partie continue, mettre à jour le message
        if (guess < gameState.secretNumber) {
            gameState.message = i18n[gameState.language].tooLow;
        } else {
            gameState.message = i18n[gameState.language].tooHigh;
        }
        // Mettre à jour uniquement le message, sans redessiner toute la liste
        dom.elements.game.message.textContent = gameState.message;
    }
}

/**
 * Affiche l'écran de fin de partie.
 * @param {boolean} didWin - True si le joueur a gagné, false sinon.
 */
function showEndGameScreen(didWin) {
    const title = dom.elements.endGame.title;
    const message = dom.elements.endGame.message;

    if (didWin) {
        title.textContent = i18n[gameState.language].winTitle;
        message.textContent = i18n[gameState.language].win.replace('{attempts}', gameState.attempts);
    } else {
        title.textContent = i18n[gameState.language].loseTitle;
        message.textContent = i18n[gameState.language].lose.replace('{secret}', gameState.secretNumber);
    }

    // Laisser un court instant pour que le joueur voie le dernier résultat
    setTimeout(() => {
        showScreen('endGame');
    }, 1000);
}

/**
 * Met à jour l'affichage (DOM).
 */
function updateDisplay() {
    // Mettre à jour l'indicateur God Mode
    dom.godModeIndicator.style.display = gameState.godMode ? 'block' : 'none';

    // Si on n'est pas sur l'écran de jeu, pas besoin de mettre à jour le reste
    if (document.querySelector('#game-screen').classList.contains('active')) {
        // Titre de l'écran de jeu
        const title = gameState.mode === 'free' 
            ? `${i18n[gameState.language].freeMode} - ${gameState.difficulty.name}`
            : `${i18n[gameState.language].adventureMode} - ${i18n[gameState.language].level} ${gameState.currentLevel}`;
        dom.elements.game.title.textContent = title;

        // Message principal (plus, moins, gagné)
        dom.elements.game.message.textContent = gameState.message;
        
        // Compteur de tentatives
        dom.elements.game.attempts.textContent = gameState.attempts;

        // Mettre à jour la liste des propositions
        dom.elements.game.previousGuesses.innerHTML = '';
        gameState.previousGuesses.slice().reverse().forEach(g => {
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center new-guess-animation';
            
            let hint = '';
            let hintClass = '';
            if (g < gameState.secretNumber) {
                hint = i18n[gameState.language].tooLow;
                hintClass = 'bg-primary';
            } else if (g > gameState.secretNumber) {
                hint = i18n[gameState.language].tooHigh;
                hintClass = 'bg-warning text-dark';
            }

            li.innerHTML = `<span>${i18n[gameState.language].guessLabel} <strong>${g}</strong></span> <span class="badge ${hintClass} rounded-pill">${hint}</span>`;
            dom.elements.game.previousGuesses.appendChild(li);
        });
    }
}

/**
 * Sauvegarde la progression dans le localStorage.
 */
function saveProgress() {
    localStorage.setItem('venere_progress', JSON.stringify({ 
        adventureProgress: gameState.adventureProgress,
        language: gameState.language
    }));
}

/**
 * Charge la progression depuis le localStorage.
 */
function loadProgress() {
    const savedData = localStorage.getItem('venere_progress');
    if (savedData) {
        const data = JSON.parse(savedData);
        gameState.adventureProgress = data.adventureProgress || 1;
        gameState.language = data.language || 'fr';
    }
}

/**
 * Active/Désactive le God Mode.
 */
function toggleGodMode() {
    gameState.godMode = !gameState.godMode;
    console.log(`God Mode: ${gameState.godMode ? 'Activé' : 'Désactivé'}`);
    // Mettre à jour l'UI pour refléter le changement
}

// ===================================
//  POINT D'ENTRÉE
// ===================================

document.addEventListener('DOMContentLoaded', initGame);

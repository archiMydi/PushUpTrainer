# PushUpTrainer

PushUpTrainer est une application mobile développée avec Flutter, conçue pour aider les utilisateurs à suivre et améliorer leurs performances en pompes. L'application utilise Firebase pour l'authentification et la synchronisation des données, et propose une interface intuitive pour une expérience utilisateur optimale.

---

## Table des matières

1. [Fonctionnalités](#fonctionnalités)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Structure du projet](#structure-du-projet)
5. [Technologies utilisées](#technologies-utilisées)
6. [Contributions](#contributions)
7. [Axes d'améliorations](#axes-daméliorations)
8. [Licence](#licence)

---

## Fonctionnalités

- **Authentification Firebase** : Connexion sécurisée via Firebase.
- **Détection des pompes** : Suivi des mouvements pour compter les pompes effectuées.
- **Synchronisation des données** : Les données sont sauvegardées et synchronisées en temps réel grâce à Firebase.
- **Interface utilisateur intuitive** : Design simple et épuré pour une navigation fluide.

---

## Installation

### Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install) (version stable recommandée)
- [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/) pour l'émulation
- Un compte Firebase configuré

### Étapes

1. Clonez le dépôt :

   git clone <URL_DU_DEPOT>
   cd push_up_trainer

2. Installez les dépendances Flutter :

   flutter pub get

3. Configurez Firebase (voir la section [Configuration](#configuration)).

4. Lancez l'application sur un émulateur ou un appareil physique :

   flutter run

---

## Configuration

### Firebase

- Créez un projet Firebase sur Firebase Console.
- Ajoutez les fichiers de configuration Firebase à votre projet :
  - Android : Placez google-services.json dans le dossier android/app.
  - iOS : Placez GoogleService-Info.plist dans le dossier ios/Runner.
- Activez les services nécessaires (authentification, Firestore, etc.) dans la console Firebase.

### Autres configurations

- Assurez-vous que les dépendances Firebase sont correctement déclarées dans pubspec.yaml.
- Vérifiez les configurations spécifiques à chaque plateforme dans les fichiers build.gradle.kts (Android) et Runner.xcodeproj (iOS).

---

## Structure du projet

push_up_trainer/
├── lib/
│ ├── main.dart # Point d'entrée de l'application
│ ├── screens/ # Écrans de l'application
│ │ └── login_screen.dart # Écran de connexion
│ ├── services/ # Services (ex : synchronisation)
│ │ └── sync_service.dart # Service de synchronisation
├── android/ # Fichiers spécifiques à Android
├── ios/ # Fichiers spécifiques à iOS
├── macos/ # Fichiers spécifiques à macOS
├── windows/ # Fichiers spécifiques à Windows
├── linux/ # Fichiers spécifiques à Linux
├── web/ # Fichiers spécifiques au web
├── pubspec.yaml # Dépendances et configurations Flutter
└── README.md # Documentation du projet

---

## Technologies utilisées

- Flutter : Framework principal pour le développement multiplateforme.
- Firebase : Backend pour l'authentification et la synchronisation des données.
- Dart : Langage de programmation utilisé avec Flutter.
- Gradle : Gestionnaire de build pour Android.

---

## Contributions

Les contributions sont les bienvenues !  
Veuillez suivre les étapes suivantes :

1. Forkez le projet.
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/nom-fonctionnalité`).
3. Commitez vos changements (`git commit -m "Ajout de la fonctionnalité X"`).
4. Poussez la branche (`git push origin feature/nom-fonctionnalité`).
5. Ouvrez une Pull Request.

---

## Axes d'améliorations

- **Ajout d'une page d'inscription**  
  Actuellement, l'inscription est uniquement possible via Firebase. Une page dédiée permettrait une meilleure expérience utilisateur.

- **Affinage de la détection des pompes**  
  Améliorer la précision de la détection des mouvements pour un comptage plus fiable.

---

## Licence

Ce projet est sous licence MIT.

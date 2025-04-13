import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; // Écran de connexion
import 'services/sync_service.dart'; // Service de synchronisation

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assure l'initialisation des widgets Flutter
  await Firebase.initializeApp(); // Initialise Firebase

  SyncService()
      .startListening(); // Démarre l'écoute des changements de connectivité pour synchroniser les données

  runApp(const MyApp()); // Lance l'application Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PushUp Challenge', // Titre de l'application
      theme: ThemeData(primarySwatch: Colors.blue), // Thème principal
      home:
          const LoginScreen(), // Définit l'écran de connexion comme écran d'accueil
    );
  }
}

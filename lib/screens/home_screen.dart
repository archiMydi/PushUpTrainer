import 'package:flutter/material.dart';
import 'package:push_up_trainer/screens/exercise_screen.dart';
import 'package:push_up_trainer/services/connectivity_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService _connectivityService =
      ConnectivityService(); // Service pour vérifier la connectivité
  bool _isConnected = true; // Indique si l'utilisateur est connecté à Internet

  @override
  void initState() {
    super.initState();

    // Vérifie la connexion initiale
    _connectivityService.checkConnection().then((connected) {
      setState(() {
        _isConnected = connected;
      });
    });

    // Écoute les changements de connectivité
    _connectivityService.connectionStream.listen((status) {
      setState(() {
        _isConnected = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Couleur de fond de l'écran
      appBar: AppBar(
        title: const Text("Tableau de bord"), // Titre de l'écran
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
            children: [
              Icon(
                _isConnected
                    ? Icons.wifi
                    : Icons.wifi_off, // Icône selon l'état de la connexion
                color:
                    _isConnected
                        ? Colors.green
                        : Colors.red, // Couleur de l'icône
                size: 64,
              ),
              const SizedBox(height: 12),
              Text(
                _isConnected
                    ? "Connecté à Internet"
                    : "Connexion perdue", // Message selon l'état de la connexion
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed:
                    _isConnected
                        ? () {
                          // Navigation vers l'écran d'exercice si connecté
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(),
                            ),
                          );
                        }
                        : null, // Désactivé si pas de connexion
                icon: const Icon(Icons.fitness_center), // Icône du bouton
                label: const Text("Démarrer l'exercice"), // Texte du bouton
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    50,
                  ), // Taille minimale du bouton
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Bordures arrondies
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

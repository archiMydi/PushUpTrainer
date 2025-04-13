import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:push_up_trainer/services/connectivity_service.dart';
import 'package:push_up_trainer/services/offline_storage_service.dart';
import 'package:push_up_trainer/services/exercise_report_service.dart';
import 'package:push_up_trainer/widgets/timer_widget.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  static const int exerciceDuration = 30; // Durée de l'exercice en secondes
  static const int objectif = 30; // Objectif de pompes à atteindre
  late Timer _timer; // Timer pour gérer le compte à rebours
  int _remainingTime = exerciceDuration; // Temps restant
  int _pushUpCount = 0; // Nombre de pompes effectuées
  StreamSubscription? _sensorSubscription; // Abonnement aux capteurs
  double _previousAccel =
      0.0; // Accélération précédente pour détecter les pompes
  bool _isExerciseActive = false; // Indique si l'exercice est en cours

  @override
  void initState() {
    super.initState();
    _startExercise(); // Démarre l'exercice dès que l'écran est affiché
  }

  @override
  void dispose() {
    // Nettoyage des ressources (timer et capteurs) lors de la fermeture de l'écran
    _timer.cancel();
    _sensorSubscription?.cancel();
    super.dispose();
  }

  void _startExercise() {
    // Initialise les variables pour démarrer l'exercice
    setState(() {
      _isExerciseActive = true;
      _remainingTime = exerciceDuration;
      _pushUpCount = 0;
    });

    // Démarre un timer pour le compte à rebours
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });
      if (_remainingTime <= 0) {
        _endExercise(); // Termine l'exercice lorsque le temps est écoulé
      }
    });

    // Écoute les événements de l'accéléromètre pour détecter les pompes
    _sensorSubscription = accelerometerEvents.listen((event) {
      final double currentAccel = event.y;
      if (_previousAccel != 0 && (currentAccel - _previousAccel).abs() > 7.0) {
        setState(() {
          _pushUpCount++; // Incrémente le compteur de pompes
        });
      }
      _previousAccel = currentAccel;
    });
  }

  void _endExercise() async {
    // Arrête le timer et l'écoute des capteurs
    _timer.cancel();
    _sensorSubscription?.cancel();
    setState(() {
      _isExerciseActive = false;
    });

    // Calcule les statistiques de l'exercice
    final double pourcentageReussi =
        (_pushUpCount / objectif * 100).clamp(0, 100).toDouble();
    final bool objectifAtteint = _pushUpCount >= objectif;
    final double pompesParSeconde = _pushUpCount / exerciceDuration;

    // Vérifie la connectivité pour synchroniser les données
    bool isConnected = await ConnectivityService().checkConnection();

    if (isConnected) {
      try {
        // Envoie le rapport en ligne
        await ExerciseReportService().enregistrerRapport(
          totalPompes: _pushUpCount,
          pompesParSeconde: pompesParSeconde,
          objectifAtteint: objectifAtteint,
          pourcentageReussi: pourcentageReussi,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rapport envoyé avec succès")),
        );
      } catch (e) {
        // Sauvegarde locale en cas d'erreur
        await OfflineStorageService().insertReport({
          'totalPompes': _pushUpCount,
          'pompesParSeconde': pompesParSeconde,
          'objectifAtteint': objectifAtteint ? 1 : 0,
          'pourcentageReussi': pourcentageReussi,
          'date': DateTime.now().toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connexion instable : sauvegarde locale"),
          ),
        );
      }
    } else {
      // Sauvegarde locale si aucune connexion
      await OfflineStorageService().insertReport({
        'totalPompes': _pushUpCount,
        'pompesParSeconde': pompesParSeconde,
        'objectifAtteint': objectifAtteint ? 1 : 0,
        'pourcentageReussi': pourcentageReussi,
        'date': DateTime.now().toIso8601String(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion perdue : sauvegarde locale")),
      );
    }

    // Affiche une boîte de dialogue avec les résultats de l'exercice
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Exercice terminé"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pompes réalisées : $_pushUpCount"),
                Text("Pompes/s : ${pompesParSeconde.toStringAsFixed(2)}"),
                Text("Objectif atteint : $objectifAtteint"),
                Text("Pourcentage : ${pourcentageReussi.toStringAsFixed(2)}%"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme la boîte de dialogue
                  Navigator.pop(context); // Retourne à l'écran précédent
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Couleur de fond
      appBar: AppBar(
        title: const Text("Exercice : Explosivité"), // Titre de l'écran
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centre horizontalement
            children: [
              TimerWidget(remainingTime: _remainingTime), // Affiche le timer
              const SizedBox(height: 30),
              Text(
                "Pompes : $_pushUpCount", // Affiche le nombre de pompes
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              if (!_isExerciseActive)
                const Text(
                  "L'exercice est terminé", // Message lorsque l'exercice est terminé
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

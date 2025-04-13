import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseReportService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instance Firebase Firestore

  // Méthode pour enregistrer un rapport d'exercice dans Firestore
  Future<void> enregistrerRapport({
    required int totalPompes,
    required double pompesParSeconde,
    required bool objectifAtteint,
    required double pourcentageReussi,
  }) async {
    try {
      // Ajoute un document dans la collection "reports"
      await _firestore.collection('reports').add({
        'totalPompes': totalPompes,
        'pompesParSeconde': pompesParSeconde,
        'objectifAtteint': objectifAtteint,
        'pourcentageReussi': pourcentageReussi,
        'date': Timestamp.now(), // Ajoute la date actuelle
      });
    } catch (e) {
      // Affiche une erreur en cas d'échec
      print("Erreur lors de l'enregistrement du rapport: $e");
    }
  }
}

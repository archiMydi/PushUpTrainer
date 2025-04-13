import 'package:push_up_trainer/services/connectivity_service.dart';
import 'package:push_up_trainer/services/offline_storage_service.dart';
import 'package:push_up_trainer/services/exercise_report_service.dart';

class SyncService {
  final ConnectivityService _connectivityService =
      ConnectivityService(); // Service de connectivité
  final OfflineStorageService _offlineStorageService =
      OfflineStorageService(); // Service de stockage hors ligne
  final ExerciseReportService _exerciseReportService =
      ExerciseReportService(); // Service pour les rapports

  // Démarre l'écoute des changements de connectivité
  void startListening() {
    _connectivityService.connectionStream.listen((isConnected) {
      if (isConnected) {
        syncPendingReports(); // Synchronise les rapports en attente si connecté
      }
    });
  }

  // Synchronise les rapports hors ligne avec Firestore
  Future<void> syncPendingReports() async {
    final pendingReports =
        await _offlineStorageService
            .getReports(); // Récupère les rapports en attente
    for (var report in pendingReports) {
      try {
        // Envoie chaque rapport à Firestore
        await _exerciseReportService.enregistrerRapport(
          totalPompes: report['totalPompes'],
          pompesParSeconde: report['pompesParSeconde'],
          objectifAtteint: report['objectifAtteint'] == 1,
          pourcentageReussi: report['pourcentageReussi'],
        );
        // Supprime le rapport de la base locale après synchronisation
        await _offlineStorageService.deleteReport(report['id']);
      } catch (e) {
        // Affiche une erreur en cas d'échec de synchronisation
        print("Erreur de synchronisation pour le rapport ${report['id']}: $e");
      }
    }
  }
}

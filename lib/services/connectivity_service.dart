import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity =
      Connectivity(); // Instance pour vérifier la connectivité
  final StreamController<bool> _controller =
      StreamController<
        bool
      >.broadcast(); // Contrôleur pour diffuser les changements de connectivité

  ConnectivityService() {
    // Écoute les changements de connectivité et met à jour le flux
    _connectivity.onConnectivityChanged.listen((result) {
      _controller.add(_isConnected(result));
    });
  }

  // Vérifie si l'utilisateur est connecté (Wi-Fi ou données mobiles)
  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
  }

  // Vérifie la connexion actuelle de manière synchrone
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  // Flux pour écouter les changements de connectivité
  Stream<bool> get connectionStream => _controller.stream;
}

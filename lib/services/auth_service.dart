import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instance Firebase pour l'authentification

  // Méthode pour se connecter avec un email et un mot de passe
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // Tente de se connecter avec Firebase
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Retourne l'utilisateur connecté
    } catch (e) {
      // Lance une exception en cas d'erreur
      throw Exception("Erreur de connexion : $e");
    }
  }
}

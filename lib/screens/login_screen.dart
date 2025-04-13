import 'package:flutter/material.dart';
import 'package:push_up_trainer/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); // Service d'authentification
  final _formKey = GlobalKey<FormState>(); // Clé pour valider le formulaire
  final TextEditingController _emailController =
      TextEditingController(); // Contrôleur pour l'email
  final TextEditingController _passwordController =
      TextEditingController(); // Contrôleur pour le mot de passe
  String _errorMessage = ''; // Message d'erreur à afficher

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Si le formulaire est valide
      try {
        // Tente de se connecter avec les identifiants
        final user = await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          // Redirige vers l'écran principal si la connexion réussit
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } catch (e) {
        // Affiche un message d'erreur en cas d'échec
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Couleur de fond
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6, // Ombre de la carte
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bordures arrondies
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey, // Associe le formulaire à la clé
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Connexion", // Titre de l'écran
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController, // Champ pour l'email
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (val) =>
                              val != null && val.isNotEmpty
                                  ? null
                                  : 'Entrez votre email', // Validation du champ
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                          _passwordController, // Champ pour le mot de passe
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // Masque le texte pour le mot de passe
                      validator:
                          (val) =>
                              val != null && val.isNotEmpty
                                  ? null
                                  : 'Entrez votre mot de passe', // Validation du champ
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit, // Appelle la méthode de connexion
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          50,
                        ), // Taille du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Bordures arrondies
                        ),
                      ),
                      child: const Text("Connexion"), // Texte du bouton
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage, // Affiche le message d'erreur
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

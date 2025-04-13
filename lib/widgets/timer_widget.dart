import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int remainingTime; // Temps restant en secondes

  const TimerWidget({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$remainingTime s", // Affiche le temps restant avec le suffixe "s"
      style: const TextStyle(
        fontSize: 48, // Taille de la police
        fontWeight: FontWeight.bold, // Texte en gras
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/welcome_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      });
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/first.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
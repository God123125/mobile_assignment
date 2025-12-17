import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khmer Cultur App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'KhmerOSbattambang',
      ),
      home: FirstScreen(),
    );
  }
}

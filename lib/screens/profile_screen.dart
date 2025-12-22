import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ProfileScreen")),
      body: Center(child: Text("ProfileScreen Result")),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}

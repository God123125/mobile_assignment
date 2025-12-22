import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OrderScreen")),
      body: Center(child: Text("OrderScreen Result")),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

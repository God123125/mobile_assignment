import 'package:flutter/material.dart';

class BgLoginWidget extends StatelessWidget {
  const BgLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset('assets/images/bg_login.png', fit: BoxFit.cover),
    );
  }
}

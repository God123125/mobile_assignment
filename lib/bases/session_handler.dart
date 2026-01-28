import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/auth/login_screen.dart';
import 'user_session.dart';

class SessionHelper {
  static bool _isAlertShowing = false;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void resetAlertFlag() {
    _isAlertShowing = false;
  }

  /// Call this whenever you detect session expiration
  static void handleSessionExpired() {
    if (_isAlertShowing) return;
    _isAlertShowing = true;

    final ctx = navigatorKey.currentState?.overlay?.context;
    if (ctx == null) {
      _isAlertShowing = false;
      return;
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Session Expired'),
          content: const Text('Your session has expired. Please login again.'),
          actions: [
            TextButton(
              onPressed: () async {
                await UserSession.clear();
                _isAlertShowing = false;

                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go to Login'),
            ),
          ],
        );
      },
    );
  }
}

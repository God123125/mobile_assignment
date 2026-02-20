import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/auth/update_password_request_model.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';

class UpdatePassword extends StatefulWidget {
  final String email; // Pass email from forgot password flow

  const UpdatePassword({super.key, required this.email});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool obscureText = true;
  final TextEditingController _confirmPassdwordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _confirmPassdwordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPassdwordController.text.trim();

    // Validation
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Password cannot be empty');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    // Call API
    final service = AuthService();
    final response = await service.updatePassword(
      UpdatePasswordRequest(
        email: widget.email,
        password: newPassword,
      ),
    );

    setState(() => _isLoading = false);

    if (response != null && response.msg.isNotEmpty) {
      _showMessage(response.msg);

      // Navigate back to login page
      Navigator.pop(context);
    } else {
      _showMessage('Failed to update password');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BgLoginWidget(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 110, 24, 16),
                child: Column(
                  children: const [
                    Text(
                      'Update Password',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please Enter new password to update your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("New Password", style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Enter new password',
                            filled: true,
                            fillColor: const Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Re-Type Password", style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _confirmPassdwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            filled: true,
                            fillColor: const Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleUpdatePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

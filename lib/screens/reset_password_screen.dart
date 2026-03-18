import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/auth/update_pass_by_old_pass_model.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final email = await UserSession.getEmail();
      if (email != null && mounted) {
        setState(() {
          _emailController.text = email;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    }
    // if (value.length < 6) {
    //   return 'Password must be at least 6 characters';
    // }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    // if (value.length < 6) {
    //   return 'Password must be at least 6 characters';
    // }
    if (value == _oldPasswordController.text) {
      return 'New password must be different from old password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Future<void> _handleSave() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Simulate API call - Replace with actual API call
  //     await Future.delayed(const Duration(seconds: 1));

  //     // TODO: Replace with actual password reset API call
  //     // Example:
  //     // final success = await AuthService.resetPassword(
  //     //   email: _emailController.text,
  //     //   oldPassword: _oldPasswordController.text,
  //     //   newPassword: _newPasswordController.text,
  //     // );

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Password updated successfully'),
  //           backgroundColor: Colors.green,
  //           duration: Duration(seconds: 2),
  //         ),
  //       );

  //       // Clear password fields
  //       _oldPasswordController.clear();
  //       _newPasswordController.clear();
  //       _confirmPasswordController.clear();

  //       // Navigate back after a short delay
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         if (mounted) {
  //           Navigator.pop(context);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error: ${e.toString()}'),
  //           backgroundColor: Colors.red,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create request model from input fields
      final request = UpdatePassByOldPassModel(
        email: _emailController.text,
        oldPass: _oldPasswordController.text,
        newPass: _newPasswordController.text,
      );

      // Call AuthService
      final response = await AuthService().updatePasswordByOld(request);

      if (response != null) {
        // Success
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Clear password fields
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          // Navigate back after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        // API returned error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update password'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2C2C2C),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // EMAIL Field
                        _buildLabel('EMAIL'),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: _emailController,
                          enabled: false,
                        ),
                        const SizedBox(height: 20),
                        // OLD PASSWORD Field
                        _buildLabel('OLD PASSWORD'),
                        const SizedBox(height: 8),
                        _buildPasswordField(
                          controller: _oldPasswordController,
                          isVisible: _isOldPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                          validator: _validateOldPassword,
                        ),
                        const SizedBox(height: 20),
                        // NEW PASSWORD Field
                        _buildLabel('NEW PASSWORD'),
                        const SizedBox(height: 8),
                        _buildPasswordField(
                          controller: _newPasswordController,
                          isVisible: _isNewPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                          validator: _validateNewPassword,
                        ),
                        const SizedBox(height: 20),
                        // CONFIRM NEW PASSWORD Field
                        _buildLabel('CONFIRM NEW PASSWORD'),
                        const SizedBox(height: 8),
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          isVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 40),
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C2C2C),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          fontSize: 16,
          color: enabled ? const Color(0xFF2C2C2C) : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        validator: validator,
        style: const TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade600,
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}

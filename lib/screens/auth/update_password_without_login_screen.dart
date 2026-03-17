import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/auth/request_to_email_model.dart';
import 'package:khmer_cultur_app/models/auth/update_password_without_login_model.dart';
import 'package:khmer_cultur_app/screens/auth/login_screen.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';
import 'package:khmer_cultur_app/widgets/code_send_widget.dart';

class UpdatePasswordWithoutLoginScreen extends StatefulWidget {
  final String email;
  const UpdatePasswordWithoutLoginScreen({super.key, required this.email});

  @override
  State<UpdatePasswordWithoutLoginScreen> createState() =>
      _UpdatePasswordWithoutLoginScreenState();
}

class _UpdatePasswordWithoutLoginScreenState
    extends State<UpdatePasswordWithoutLoginScreen> {
  late TextEditingController code1;
  late TextEditingController code2;
  late TextEditingController code3;
  late TextEditingController code4;
  late TextEditingController code5;
  late TextEditingController code6;

  late FocusNode focus1;
  late FocusNode focus2;
  late FocusNode focus3;
  late FocusNode focus4;
  late FocusNode focus5;
  late FocusNode focus6;
  final AuthService authService = AuthService();
  int _resendSeconds = 60;
  bool _canResend = false;
  late Timer _timer;
  bool _isVerifying = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    startResendTimer();
    code1 = TextEditingController();
    code2 = TextEditingController();
    code3 = TextEditingController();
    code4 = TextEditingController();
    code5 = TextEditingController();
    code6 = TextEditingController();

    focus1 = FocusNode();
    focus2 = FocusNode();
    focus3 = FocusNode();
    focus4 = FocusNode();
    focus5 = FocusNode();
    focus6 = FocusNode();

    // Auto-focus the first box when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focus1);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    code1.dispose();
    code2.dispose();
    code3.dispose();
    code4.dispose();
    code5.dispose();
    code6.dispose();

    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    focus5.dispose();
    focus6.dispose();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      _resendSeconds = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.chevron_left, size: 32, color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          BgLoginWidget(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 110, 24, 16),
                child: Column(
                  children: [
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'We have sent a code to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 18, right: 18, left: 18),
                  decoration: BoxDecoration(
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
                        // Code Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Code", style: TextStyle(fontSize: 14)),
                            TextButton(
                              onPressed: _canResend
                                  ? () async {
                                      final resendModel = RequestToEmailModel(
                                        email: widget.email,
                                      );
                                      final success = await authService
                                          .requestoEmail(resendModel);
                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Code resent to ${widget.email}",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        startResendTimer();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Failed to resend code",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: Text(
                                _canResend
                                    ? "Resend Code"
                                    : "Resend in $_resendSeconds sec",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _canResend ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Code Boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CodeBoxWidget(
                              controller: code1,
                              focusNode: focus1,
                              nextFocus: focus2,
                            ),
                            CodeBoxWidget(
                              controller: code2,
                              focusNode: focus2,
                              nextFocus: focus3,
                              previousFocus: focus1,
                            ),
                            CodeBoxWidget(
                              controller: code3,
                              focusNode: focus3,
                              nextFocus: focus4,
                              previousFocus: focus2,
                            ),
                            CodeBoxWidget(
                              controller: code4,
                              focusNode: focus4,
                              nextFocus: focus5,
                              previousFocus: focus3,
                            ),
                            CodeBoxWidget(
                              controller: code5,
                              focusNode: focus5,
                              nextFocus: focus6,
                              previousFocus: focus4,
                            ),
                            CodeBoxWidget(
                              controller: code6,
                              focusNode: focus6,
                              previousFocus: focus5,
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        // New Password
                        Text("New Password"),
                        SizedBox(height: 8),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter new password",
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        // Confirm Password
                        Text("Confirm Password"),
                        SizedBox(height: 8),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirm password",
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Reset Password Button at bottom
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isVerifying ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isVerifying
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'RESET PASSWORD',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 25),
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

  // Add this helper function in the state
  Future<void> _resetPassword() async {
    String code =
        code1.text +
        code2.text +
        code3.text +
        code4.text +
        code5.text +
        code6.text;

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter full verification code"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    final request = UpdatePasswordWithoutLoginModel(
      email: widget.email,
      code: code,
      newPass: newPasswordController.text,
    );

    final result = await authService.updatePasswordWithoutLoginModel(request);

    setState(() => _isVerifying = false);

    if (!mounted) return;

    if (result != null && result.msg.toLowerCase().contains("success")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.msg), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result?.msg ?? "Reset password failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

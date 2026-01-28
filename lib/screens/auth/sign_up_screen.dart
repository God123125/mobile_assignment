import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khmer_cultur_app/models/auth/register_model.dart';
import 'package:khmer_cultur_app/screens/auth/verification_screen.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscureText = true;
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final AuthService userService = AuthService();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (isLoading) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => isLoading = true);
    final user = RegisterModel(
      name: username,
      email: email,
      password: password,
      phone: phone,
    );

    final success = await userService.registerUser(user);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Already Sign up, Please check your email'), backgroundColor: Colors.orange),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Please sign up to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20), 
                  padding: EdgeInsets.only(top: 18,right: 18,left: 18),
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
                        Text("Username", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Username',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                        SizedBox(height: 14),
                        Text("Email", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                        SizedBox(height: 14),
                        Text("Phone", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, 
                            LengthLimitingTextInputFormatter(10), 
                          ],
                          decoration: InputDecoration(
                            hintText: '0123...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                        SizedBox(height: 14),
                        Text("Password", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
                          controller: passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        SizedBox(height: 14),
                        Text("Re-Type Password", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        SizedBox(height: 40), 
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 20), 
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
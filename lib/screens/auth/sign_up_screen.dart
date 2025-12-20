import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/auth/login_screen.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscureText = true;

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
                        Text("Password", style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        TextField(
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // Safe bottom padding
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
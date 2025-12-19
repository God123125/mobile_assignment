import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/auth/forgot_password_screen.dart';
import 'package:khmer_cultur_app/screens/auth/sign_up_screen.dart';
import 'package:khmer_cultur_app/screens/home_screen.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BgLoginWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please sign in to your existing account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              //card  login
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.35,
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email"),
                        SizedBox(height: 4),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Password"),
                        SizedBox(height: 4),
                        TextField(
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                            filled: true,
                            fillColor: Color(0xFFF0F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                            suffixIcon: IconButton(
                              icon: Icon(obscureText? Icons.visibility_off: Icons.visibility,color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  fillColor: WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return Colors.blue;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Text('Remember me'),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                              },
                              child: Text('Forgot Password',style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,  MaterialPageRoute(builder: (context) => SignUpScreen()));
                              },
                              child: Text('Sign Up',style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(child: Text('Or')),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialButton(Icons.facebook, Colors.blue[800]!),
                            SizedBox(width: 24),
                            socialButton(Icons.alternate_email,Colors.lightBlue,),
                            SizedBox(width: 24),
                            socialButton(Icons.apple, Colors.black),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget socialButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: color,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: () {},
      ),
    );
  }
}

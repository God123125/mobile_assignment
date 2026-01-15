import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/edit_profile_screen.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  IconButton(
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Color(0xFF2C2C2C), size: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Title
                  Text(
                    "Personal Info",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  // Edit Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    child: Text(
                      "EDIT",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: AssetImage('assets/images/welcom1.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kim Mina",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "kimmina@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Personal Details Card
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Full Name Row
                            _buildInfoRow(
                              icon: Icons.person_outline,
                              iconColor: Colors.orange,
                              label: "FULL NAME",
                              value: "Kim Mina",
                              isLast: false,
                            ),
                            // Email Row
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              iconColor: Colors.blue,
                              label: "EMAIL",
                              value: "kimmina@gmail.com",
                              isLast: false,
                            ),
                            // Phone Number Row
                            _buildInfoRow(
                              icon: Icons.phone_outlined,
                              iconColor: Colors.lightBlue,
                              label: "PHONE NUMBER",
                              value: "0886545434",
                              isLast: true,
                            ),
                          ],
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
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isLast,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

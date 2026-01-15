import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/add_new_address_screen.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

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
                  SizedBox(width: 16),
                  // Title
                  Text(
                    "My Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
            ),

            // Address Cards
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      // Home Address Card
                      _buildAddressCard(
                        icon: Icons.home,
                        iconColor: Colors.blue,
                        iconBackgroundColor: Colors.lightBlue.shade100,
                        title: "HOME",
                        streetAddress: "2464 Royal Ln. Mesa, New Jersey",
                        zipCode: "45463",
                        onEdit: () {
                          // Handle edit
                        },
                        onDelete: () {
                          // Handle delete
                        },
                      ),
                      SizedBox(height: 16),
                      // Work Address Card
                      _buildAddressCard(
                        icon: Icons.business,
                        iconColor: Colors.purple,
                        iconBackgroundColor: Colors.purple.shade100,
                        title: "WORK",
                        streetAddress: "3891 Ranchview Dr. Richardson, California",
                        zipCode: "62639",
                        onEdit: () {
                          // Handle edit
                        },
                        onDelete: () {
                          // Handle delete
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Add New Address Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddNewAddressScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    "ADD NEW ADDRESS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
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

  Widget _buildAddressCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String streetAddress,
    required String zipCode,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          // Address Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(streetAddress, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                SizedBox(height: 4),
                Text(zipCode, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          // Edit and Delete Icons
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue, size: 22),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.blue, size: 22),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/address_screen.dart';
import 'package:khmer_cultur_app/screens/personal_info_screen.dart';
import 'package:khmer_cultur_app/screens/card_profile_screen.dart';
import 'package:khmer_cultur_app/screens/favorite_screen.dart';
import 'package:khmer_cultur_app/screens/notification_screen.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Color(0xFF2C2C2C)),
                    onPressed: () {
                      // Handle menu button
                    },
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

            // Navigation Options
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // First Card
                      _buildNavigationCard(
                        context,
                        items: [
                          _NavigationItem(
                            icon: Icons.person_outline,
                            title: "Personal Info",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                              );
                            },
                          ),
                          _NavigationItem(
                            icon: Icons.location_on_outlined,
                            title: "Addresses",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddressScreen()),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Second Card
                      _buildNavigationCard(
                        context,
                        items: [
                          _NavigationItem(
                            icon: Icons.shopping_cart_outlined,
                            title: "Cart",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CartProfileScreen()),
                              );
                            },
                          ),
                          _NavigationItem(
                            icon: Icons.favorite_border,
                            title: "Favourite",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                              );
                            },
                          ),
                          _NavigationItem(
                            icon: Icons.notifications_outlined,
                            title: "Notifications",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationScreen()),
                              );
                            },
                          ),
                          _NavigationItem(icon: Icons.language, title: "Language", onTap: () {}),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Third Card
                      _buildNavigationCard(
                        context,
                        items: [
                          _NavigationItem(icon: Icons.help_outline, title: "FAQs", onTap: () {}),
                        ],
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

  Widget _buildNavigationCard(BuildContext context, {required List<_NavigationItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.indexOf(item) == items.length - 1;
          return InkWell(
            onTap: item.onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: Color(0xFF2C2C2C), size: 24),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2C2C2C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _NavigationItem({required this.icon, required this.title, required this.onTap});
}

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/restaurant_screen.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/card_box_widget.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;
  final List<Map<String, String>> categories = [
    {"title": "All", "image": "assets/images/welcom1.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom2.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom3.png"},
    {"title": "Fast Food", "image": "assets/images/welcom3.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom1.png"},
    {"title": "Chinese", "image": "assets/images/welcom2.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom3.png"},
    {"title": "Fast Food", "image": "assets/images/welcom3.png"},
  ];
  final List<Map<String, dynamic>> souvenirs = [
    {
      "image": "assets/images/welcom1.png",
      "titleKh": "ខ្មែរសំលៀកបំពាក់",
      "titleEn": "Khmer Traditional Clothing",
      "rating": 4.7,
      "delivery": "Free",
    },
    {
      "image": "assets/images/welcom1.png",
      "titleKh": "កាបូបដៃខ្មែរ",
      "titleEn": "Khmer Handbag",
      "rating": 4.5,
      "delivery": "Free",
    },
    {
      "image": "assets/images/welcom1.png",
      "titleKh": "សំបកទូរស័ព្ទដៃ",
      "titleEn": "Phone Case",
      "rating": 4.8,
      "delivery": "Free",
    },
    {
      "image": "assets/images/welcom1.png",
      "titleKh": "គ្រឿងល្ខោនខ្មែរ",
      "titleEn": "Khmer Ornaments",
      "rating": 4.6,
      "delivery": "Free",
    },
    {
      "image": "assets/images/welcom1.png",
      "titleKh": "ខ្សែដៃសម្លៀកបំពាក់",
      "titleEn": "Clothing Bracelet",
      "rating": 4.9,
      "delivery": "Free",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: SearchBox()),
                SizedBox(width: 8),
                CardBox(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "All Categories",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    color: Colors.transparent,
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        bool isSelected = index == selectedIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8,top: 5,bottom: 5,),
                            padding: EdgeInsets.fromLTRB(8, 8 , 14, 8),
                            decoration: BoxDecoration(
                              color: isSelected? Color(0xFF94D2FF): Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE2E2E2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, 
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    color: Colors.grey.shade200,
                                    child: Image.asset(
                                      item["image"]!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    item["title"]!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Open Restaurants",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantScreen(),
                        ),
                      );
                    },
                    child: Column(
                      children: souvenirs.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    item['image'] ?? '',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['titleKh'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['titleEn'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item['rating'].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(width: 24),
                                    Icon(
                                      Icons.local_shipping,
                                      size: 24,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item['delivery'] ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

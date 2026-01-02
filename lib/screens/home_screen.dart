import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/menu_screen.dart';
import 'package:khmer_cultur_app/widgets/home/card_gride.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/card_box_widget.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> categories = [
    {"title": "Khmer Food", "image": "assets/images/welcom1.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom2.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom3.png"},
    {"title": "Fast Food", "image": "assets/images/welcom3.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom1.png"},
    {"title": "Chinese", "image": "assets/images/welcom2.png"},
    {"title": "Khmer Food", "image": "assets/images/welcom3.png"},
    {"title": "Fast Food", "image": "assets/images/welcom3.png"},
  ];
  List<Map<String, String>> products = [
    {
      "title": "Spacal promotion from Khmer food",
      "image":"assets/images/welcom1.png",
    },
    {
      "title": "1984",
      "image":"assets/images/welcom1.png",
    },
    {
      "title": "To Kill a Mockingbird",
      "image":"assets/images/welcom1.png",
    },
    {
      "title": "The Great Gatsby",
      "image":"assets/images/welcom1.png",
    },
    {
      "title": "1984",
      "image":"assets/images/welcom1.png",
    },
    {
      "title": "To Kill a Mockingbird",
      "image":"assets/images/welcom1.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, 
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DELIVER TO",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Halal Lab office',
                  child: Text('Halal Lab office'),
                ),
                PopupMenuItem(value: 'Main Office', child: Text('Main Office')),
                PopupMenuItem(value: 'Warehouse', child: Text('Warehouse')),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Halal Lab office",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CardBox(),
        ],
      ),
      body: Column(
        children: [
          SearchBox(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 226, 226, 226),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final item = categories[index];
              
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MenuScreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8,),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: Image.asset(
                                        item["image"]!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    item["title"]!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/images/promo1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        return CardGridHome(
                          title: products[index]['title']!,
                          image: products[index]['image']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

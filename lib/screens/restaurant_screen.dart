import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/item_detail_screen.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/restaurant/card_gride.dart';
import 'package:khmer_cultur_app/widgets/restaurant/card_list.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> listCards = [];
  bool isGridMode = false;
  PageController pageController = PageController();
  final List<Map<String, String>> categories = [
    {"title": "All"},
    {"title": "Khmer Food"},
    {"title": "Khmer Food"},
    {"title": "Fast Food"},
    {"title": "Khmer Food"},
    {"title": "Khmer Food"},
    {"title": "Fast Food"},
  ];
  List<Map<String, dynamic>> product = [
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 1",
      "sold": 2000,
      "liked": 963,
      "limitPurchase": 2,
      "price": 25.0,
      "fav": true,
      "originalPrice": 2800.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 2",
      "sold": 1500,
      "liked": 820,
      "limitPurchase": 3,
      "price": 30.0,
      "fav": false,
      "originalPrice": 2800.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 3",
      "sold": 1800,
      "liked": 900,
      "limitPurchase": 1,
      "price": 15.0,
      "fav": true,
      "originalPrice": 2900.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 4",
      "sold": 2200,
      "liked": 1050,
      "limitPurchase": 2,
      "price": 40.0,
      "fav": false,
      "originalPrice": 2800.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 5",
      "sold": 900,
      "liked": 450,
      "limitPurchase": 5,
      "price": 10.0,
      "fav": true,
      "originalPrice": 2800.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 6",
      "sold": 3000,
      "liked": 1200,
      "limitPurchase": 2,
      "price": 55.0,
      "fav": false,
      "originalPrice": 3800.0,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 7",
      "sold": 500,
      "liked": 200,
      "limitPurchase": 3,
      "price": 8.0,
      "fav": true,
      "originalPrice": 2800.6,
    },
    {
      "image": "assets/images/welcom3.png",
      "title": "Product 8",
      "sold": 2500,
      "liked": 1100,
      "limitPurchase": 1,
      "price": 60.0,
      "fav": false,
      "originalPrice": 2800.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
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
            child: const Icon(Icons.chevron_left, size: 32, color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 28,
                color: Colors.blue,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/first.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.blue, size: 24),
                  SizedBox(width: 4),
                  Text("4.7", style: TextStyle(fontSize: 14)),
                  SizedBox(width: 24),
                  Icon(Icons.local_shipping, size: 24, color: Colors.blue),
                  SizedBox(width: 4),
                  Text("Free", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage("assets/images/first.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ផ្ទះអ្នកសៀមរាប",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Spicy restaurant",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 6),
              child: Row(
                children: [
                  Text(
                    "Toast Chain No.1 in Cambodia",
                    style: TextStyle(color: Colors.blue.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Maecenas sed diam eget risus varius blandit sit amet non magna. Maecenas sed diam eget risus varius blandit sit amet non magna.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.transparent,
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: EdgeInsets.symmetric(horizontal: 6),
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
                      margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF94D2FF) : Colors.white,
                        borderRadius: BorderRadius.circular(29),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
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
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${categories[selectedIndex]["title"]} (${categories.length})",
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(isGridMode ? Icons.grid_view : Icons.list),
                    onPressed: () {
                      setState(() {
                        isGridMode = !isGridMode;
                      });
                    },
                  ),
                ],
              ),
            ),

            isGridMode
                ? GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    itemCount: product.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final item = product[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemDetailScreen(item: item),
                            ),
                          );
                        },
                        child: CardGrid(
                          title: item['title'],
                          price: item['price'],
                          imgUrl: item['image'],
                          sold: item['sold'],
                          liked: item['liked'],
                          limitPurchase: item['limitPurchase'],
                          isFav: item['fav'],
                          originalPrice: item['originalPrice'],
                          onTabCard: () {
                            listCards.add(item);
                          },
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: product.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = product[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemDetailScreen(item: item),
                            ),
                          );
                        },
                        child: CardList(
                          title: item['title'],
                          price: item['price'],
                          imgUrl: item['image'],
                          sold: item['sold'],
                          liked: item['liked'],
                          limitPurchase: item['limitPurchase'],
                          isFav: item['fav'],
                          originalPrice: item['originalPrice'],
                          onTabCard: () {
                            listCards.add(item);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

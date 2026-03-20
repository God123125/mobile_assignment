import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/restaurant_screen.dart';
import 'package:khmer_cultur_app/services/store_category_service.dart';
import 'package:khmer_cultur_app/services/store_service.dart';
import 'package:khmer_cultur_app/shimmer_loading/menu_shimmer.dart';
import 'package:khmer_cultur_app/utils/location_util.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/card_box_widget.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class MenuScreen extends StatefulWidget {
  final String? selectedCategoryId;

  const MenuScreen({super.key, this.selectedCategoryId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;
  final StoreCategoryService _categoryService = StoreCategoryService();
  final StoreService _storeService = StoreService();

  List<StoreCategory> categories = [];
  List<Map<String, dynamic>> storesWithDistance = [];
  List<Map<String, dynamic>> filteredStores = [];
  bool isLoading = true;
  double? userLat;
  double? userLon;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final categoryData = await _categoryService.fetchCategories();
      final storeData = await _storeService.fetchStores();

      // Add "All" category at the start
      categories = [
        StoreCategory(
          id: 'all',
          name: '  All  ',
          description: '',
          imageUrl: '',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ...categoryData,
      ];

      // Compute distance for each store
      storesWithDistance = [];

      for (var store in storeData) {
        final distanceStr = await LocationUtils.getDistanceKm(
          store: store,
          userLat: userLat,
          userLon: userLon,
        );

        final distanceValue = distanceStr == "Unknown"
            ? double.infinity
            : double.tryParse(distanceStr.replaceAll(" km", "")) ??
                  double.infinity;

        storesWithDistance.add({
          'store': store,
          'distanceKmStr': distanceStr,
          'distanceKm': distanceValue,
        });
      }

      // Sort stores by distance
      storesWithDistance.sort((a, b) {
        return (a['distanceKm'] as double).compareTo(b['distanceKm'] as double);
      });

      // Determine initial selected category
      if (widget.selectedCategoryId != null) {
        selectedIndex = categories.indexWhere(
          (cat) => cat.id == widget.selectedCategoryId,
        );
        if (selectedIndex == -1) selectedIndex = 0;
      }

      filterStores(selectedIndex);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading MenuScreen data: $e");
    }
  }

  void filterStores(int index) {
    final selectedCategory = categories[index];
    setState(() {
      selectedIndex = index;

      if (selectedCategory.id == 'all') {
        filteredStores = storesWithDistance;
      } else {
        filteredStores = storesWithDistance.where((item) {
          final store = item['store'] as Store;
          return store.storeCategory.id == selectedCategory.id;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const MenuShimmer()
          : Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: const [
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
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Categories",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, index) {
                              final item = categories[index];
                              final isSelected = index == selectedIndex;

                              return GestureDetector(
                                onTap: () => filterStores(index),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 8,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    8,
                                    12,
                                    8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF94D2FF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFFE2E2E2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      if (item.id != 'all') ...[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          child: Image.network(
                                            item.imageUrl,
                                            width: 45,
                                            height: 45,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        item.name,
                                        style: const TextStyle(
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
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Open Restaurants",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        filteredStores.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    "No stores available",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: filteredStores.map((item) {
                                  final store = item['store'] as Store;
                                  final distanceStr =
                                      item['distanceKmStr'] as String;
                                  final deliveryFee =
                                      LocationUtils.getDeliveryFee(
                                        store: store,
                                        userLat: userLat,
                                        userLon: userLon,
                                      );

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              RestaurantScreen(store: store),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.network(
                                                store.imageUrl,
                                                width: double.infinity,
                                                height: 180,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              store.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              store.merchant.address,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  store.rating.toStringAsFixed(
                                                    1,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  distanceStr,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Icon(
                                                  Icons.local_shipping,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  deliveryFee,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

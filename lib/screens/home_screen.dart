// import 'package:flutter/material.dart';
// import 'package:khmer_cultur_app/models/ad_image_model.dart';
// import 'package:khmer_cultur_app/models/product_model.dart';
// import 'package:khmer_cultur_app/models/store_model.dart';
// import 'package:khmer_cultur_app/screens/item_detail_screen.dart';
// import 'package:khmer_cultur_app/screens/menu_screen.dart';
// import 'package:khmer_cultur_app/screens/product_screen.dart';
// import 'package:khmer_cultur_app/services/ad_image_service.dart';
// import 'package:khmer_cultur_app/services/address_service.dart';
// import 'package:khmer_cultur_app/services/store_category_service.dart';
// import 'package:khmer_cultur_app/services/product_service.dart';
// import 'package:khmer_cultur_app/shimmer_loading/home_shimmer.dart';
// import 'package:khmer_cultur_app/widgets/home/card_gride.dart';
// import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
// import 'package:khmer_cultur_app/widgets/card_box_widget.dart';
// import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final StoreCategoryService _categoryService = StoreCategoryService();
//   List<StoreCategory> categories = [];
//   bool isCategoriesLoading = true;

//   final ProductService _productService = ProductService();
//   List<Product> products = [];
//   bool isProductsLoading = true;
//   String? productsError;

//   final AdvertisingService _advertisingService = AdvertisingService();
//   List<Advertising> advertisings = [];
//   bool isAdsLoading = true;

//   double? userLat;
//   double? userLon;
//   bool isLocationLoading = true;
//   String? selectedAddress;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     await Future.wait([
//       _loadCategories(),
//       _loadProducts(),
//       _loadAdvertisings(),
//       _loadSavedAddress(),
//     ]);
//   }

//   Future<void> _loadSavedAddress() async {
//     final saved = await AddressStorageService.getSelectedAddress();

//     if (saved != null) {
//       setState(() {
//         selectedAddress = saved;
//       });
//     }
//   }

//   Future<void> _loadAdvertisings() async {
//     try {
//       final data = await _advertisingService.fetchAdvertisings();
//       if (mounted) {
//         setState(() {
//           advertisings = data;
//           isAdsLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => isAdsLoading = false);
//       }
//       debugPrint("Ads error: $e");
//     }
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final data = await _categoryService.fetchCategories();
//       if (mounted) {
//         setState(() {
//           categories = data;
//           isCategoriesLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => isCategoriesLoading = false);
//       }
//       debugPrint("Categories error: $e");
//     }
//   }

//   Future<void> _loadProducts() async {
//     try {
//       final fetchedProducts = await _productService.fetchProductsWithStore();
//       if (mounted) {
//         setState(() {
//           products = fetchedProducts;
//           isProductsLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isProductsLoading = false;
//           productsError = e.toString().replaceFirst('Exception: ', '');
//         });
//       }
//       debugPrint("Products error: $e");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.grey.shade200,
//             child: const Icon(Icons.shopping_cart_outlined, color: Colors.blue),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "DELIVER TO ",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 debugPrint(value);
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: selectedAddress,
//                   child: Text(selectedAddress ?? "Select Address"),
//                 ),
//               ],
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 150,
//                     child: Text(
//                       selectedAddress ?? "Select Address",
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const Icon(Icons.keyboard_arrow_down, size: 18),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: const [CardBox()],
//       ),
//       body: isCategoriesLoading || isProductsLoading
//           ? const HomeShimmer()
//           : Column(
//               children: [
//                 const SearchBox(),
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: _loadData,
//                     child: SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Category horizontal list
//                           Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Container(
//                               width: double.infinity,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: isCategoriesLoading
//                                   ? const Center(
//                                       child: CircularProgressIndicator(),
//                                     )
//                                   : categories.isEmpty
//                                   ? const Center(child: Text("No categories"))
//                                   : ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: categories.length,
//                                       itemBuilder: (context, index) {
//                                         final item = categories[index];
//                                         return GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => MenuScreen(
//                                                   selectedCategoryId: item.id,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 15,
//                                               vertical: 8,
//                                             ),
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Container(
//                                                   width: 60,
//                                                   height: 60,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           35,
//                                                         ),
//                                                     color: Colors.grey.shade200,
//                                                   ),
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           35,
//                                                         ),
//                                                     child: Image.network(
//                                                       item.imageUrl,
//                                                       fit: BoxFit.cover,
//                                                       errorBuilder: (_, _, _) =>
//                                                           const Icon(
//                                                             Icons
//                                                                 .image_not_supported,
//                                                             size: 30,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 4),
//                                                 Text(
//                                                   item.name,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                             ),
//                           ),

//                           // Promotion banner: top 1 ad only
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             child: advertisings.isEmpty
//                                 ? const SizedBox()
//                                 : GestureDetector(
//                                     onTap: () {
//                                       // Navigate to ProductScreen
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => const ProductScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(16),
//                                       child: Image.network(
//                                         advertisings.first.adImage,
//                                         height: 180,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, _, _) => const Icon(
//                                           Icons.image_not_supported,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                           // Products section
//                           Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Popular Items",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),

//                                 if (isProductsLoading)
//                                   const Center(
//                                     child: CircularProgressIndicator(),
//                                   )
//                                 else if (productsError != null)
//                                   Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(24),
//                                       child: Text(
//                                         "Failed to load products\n$productsError",
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 else if (products.isEmpty)
//                                   const Center(
//                                     child: Text("No products available"),
//                                   )
//                                 else
//                                   GridView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: products.length,
//                                     gridDelegate:
//                                         const SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           childAspectRatio: 0.68,
//                                           crossAxisSpacing: 16,
//                                           mainAxisSpacing: 16,
//                                         ),
//                                     itemBuilder: (context, index) {
//                                       final product = products[index];
//                                       return GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ItemDetailScreen(
//                                                     item: product,
//                                                   ),
//                                             ),
//                                           );
//                                         },
//                                         child: CardGridHome(
//                                           title: product.name,
//                                           image: product.imageUrl,
//                                           price: product.price,
//                                           priceAfterDis:
//                                               product.priceAfterDiscount,
//                                           dis: product.discount,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//       bottomNavigationBar: const BottomNavBar(currentIndex: 0),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/ad_image_model.dart';
import 'package:khmer_cultur_app/models/category_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/auto_slide.dart';
import 'package:khmer_cultur_app/screens/menu_screen.dart';
import 'package:khmer_cultur_app/screens/product_screen.dart';
import 'package:khmer_cultur_app/services/ad_image_service.dart';
import 'package:khmer_cultur_app/services/address_service.dart';
import 'package:khmer_cultur_app/services/category_service.dart';
import 'package:khmer_cultur_app/services/store_category_service.dart';
import 'package:khmer_cultur_app/shimmer_loading/home_shimmer.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/card_box_widget.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StoreCategoryService _categoryService = StoreCategoryService();
  List<StoreCategory> categories = [];
  bool isCategoriesLoading = true;

  final AdvertisingService _advertisingService = AdvertisingService();
  List<Advertising> advertisings = [];
  bool isAdsLoading = true;

  final CategoryModelService _productCategoryService = CategoryModelService();
  List<CategoryModel> productCategories = [];
  bool isProductCategoriesLoading = true;

  double? userLat;
  double? userLon;
  bool isLocationLoading = true;
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadCategories(),
      _loadAdvertisings(),
      _loadSavedAddress(),
      _loadProductCategories(),
    ]);
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _categoryService.fetchCategories();
      if (mounted) {
        setState(() {
          categories = data;
          isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isCategoriesLoading = false);
      debugPrint("Categories error: $e");
    }
  }

  Future<void> _loadSavedAddress() async {
    final saved = await AddressStorageService.getSelectedAddress();
    if (saved != null) {
      setState(() {
        selectedAddress = saved;
      });
    }
  }

  Future<void> _loadAdvertisings() async {
    try {
      final data = await _advertisingService.fetchAdvertisings();
      if (mounted) {
        setState(() {
          advertisings = data;
          isAdsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isAdsLoading = false);
      }
      debugPrint("Ads error: $e");
    }
  }

  Future<void> _loadProductCategories() async {
    try {
      final data = await _productCategoryService.getCategories();
      if (mounted) {
        setState(() {
          productCategories = data;
          isProductCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isProductCategoriesLoading = false);
      }
      debugPrint("Categories error: $e");
    }
  }

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
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.blue),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DELIVER TO ",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                debugPrint(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: selectedAddress,
                  child: Text(selectedAddress ?? "Select Address"),
                ),
              ],
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      selectedAddress ?? "Select Address",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ),
            ),
          ],
        ),
        actions: const [CardBox()],
      ),
      body: isCategoriesLoading || isAdsLoading
          ? const HomeShimmer()
          : Column(
              children: [
                const SearchBox(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category horizontal list
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
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: isCategoriesLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : categories.isEmpty
                                  ? const Center(child: Text("No categories"))
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) {
                                        final item = categories[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MenuScreen(
                                                  selectedCategoryId: item.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 5,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                    child: Image.network(
                                                      item.imageUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, _, _) =>
                                                          const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
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
                          ),
                          AutoSlide(
                            slideImages: [
                              "https://image.freshnewsasia.com/2020/id-154/fn-2021-04-01-15-58-31-0.jpg",
                              "https://www.chipmongbank.com.kh/api/images/a20ca31c-6fe2-4a67-8218-d3314261a62b.png",
                              "https://foodbuzz.site/api/v1/files/b8159bbf-21dd-4908-b758-8700c3f40d8e",
                            ],
                            height: 250,
                          ),
                          // Advertising Grid Section
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Top Advertising",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                if (isAdsLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (advertisings.isEmpty)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Text(
                                        "No advertisements available",
                                      ),
                                    ),
                                  )
                                else
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: advertisings.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio:
                                              0.75, // taller than wide for vertical card
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                    itemBuilder: (context, index) {
                                      final ad = advertisings[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const ProductScreen(),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // Image on top
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.vertical(
                                                        top: Radius.circular(
                                                          16,
                                                        ),
                                                      ),
                                                  child: Image.network(
                                                    ad.adImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => Container(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          child: const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              // Description below
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                color: Colors.white,
                                                child: Text(
                                                  ad.description,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

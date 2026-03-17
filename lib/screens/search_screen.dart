// import 'package:flutter/material.dart';
// import 'package:khmer_cultur_app/widgets/search_widget.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> _searchResults = [];

//   final List<String> _items = [
//     "Pizza",
//     "Burger",
//     "Khmer Food",
//     "Thai Food",
//     "Chinese Food",
//     "Fast Food",
//   ];

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchResults = _items
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _onClear() {
//     setState(() {
//       _searchResults.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Search", style: TextStyle(fontSize: 16)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             SearchWidget(
//               controller: _searchController,
//               hintText: "Search dishes, restaurants",
//               onChanged: _onSearchChanged,
//               onClear: _onClear,
//             ),
//             SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/product_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/item_detail_screen.dart';
import 'package:khmer_cultur_app/screens/restaurant_screen.dart';
import 'package:khmer_cultur_app/services/product_service.dart';
import 'package:khmer_cultur_app/services/store_service.dart';
import 'package:khmer_cultur_app/widgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final StoreService _storeService = StoreService();

  List<Store> _stores = [];
  List<Store> _filteredStores = [];
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStores();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await _productService.fetchProductsWithStore();

      setState(() {
        _products = data;
        _filteredProducts = data;
      });
    } catch (e) {
      debugPrint("Product error: $e");
    }
  }

  Future<void> fetchStores() async {
    try {
      final data = await _storeService.fetchStores();
      setState(() {
        _stores = data;
        _filteredStores = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    query = query.toLowerCase();

    setState(() {
      /// FILTER STORES
      _filteredStores = _stores.where((store) {
        return store.name.toLowerCase().contains(query);
      }).toList();

      /// FILTER PRODUCTS
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onClear() {
    _searchController.clear();
    setState(() {
      _filteredStores = _stores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            /// SEARCH BAR
            SearchWidget(
              controller: _searchController,
              hintText: "Search dishes, restaurants",
              onChanged: _onSearchChanged,
              onClear: _onClear,
            ),

            const SizedBox(height: 10),

            /// TITLE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Suggested Restaurants",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),

            /// STORE LIST
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: [
                        ...(_searchController.text.isEmpty
                                ? _stores.take(4).toList()
                                : _filteredStores)
                            .map((store) => storeItem(store)),
                        const SizedBox(height: 10),
                        Text(
                          _searchController.text.isEmpty
                              ? "Suggested Dishes"
                              : "Matched Dishes",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _searchController.text.isEmpty
                              ? _products
                                    .where(
                                      (p) => _stores
                                          .take(4)
                                          .map((s) => s.id)
                                          .contains(p.storeInfo?.id),
                                    )
                                    .length
                              : _filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                          itemBuilder: (context, index) {
                            final product = _searchController.text.isEmpty
                                ? _products
                                      .where(
                                        (p) => _stores
                                            .take(4)
                                            .map((s) => s.id)
                                            .contains(p.storeInfo?.id),
                                      )
                                      .toList()[index]
                                : _filteredProducts[index];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ItemDetailScreen(
                                      item: product,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Image.network(
                                          product.imageUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.storeInfo?.name ?? "",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "\$${product.price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
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
          ],
        ),
      ),
    );
  }

  Widget storeItem(Store store) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(
              store: store,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(store.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text("4.5", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/product_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/confirm_order_screen.dart';
import 'package:khmer_cultur_app/screens/item_detail_screen.dart';
import 'package:khmer_cultur_app/services/cart_storage_service.dart';
import 'package:khmer_cultur_app/services/product_service.dart';
import 'package:khmer_cultur_app/shimmer_loading/restaurant_shimmer.dart';
import 'package:khmer_cultur_app/utils/location_util.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/restaurant/card_gride.dart';
import 'package:khmer_cultur_app/widgets/restaurant/card_list.dart';
import 'package:khmer_cultur_app/widgets/summary_total_widget.dart';

class RestaurantScreen extends StatefulWidget {
  final Store store;

  const RestaurantScreen({
    super.key,
    required this.store,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ProductService _productService = ProductService();
  final CartStorageService _cartService =
      CartStorageService(); // Use the service

  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<String> categories = [];
  int selectedIndex = 0;
  bool isGridMode = false;
  bool isLoading = true;
  double? userLat;
  double? userLon;
  Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    loadProducts();
    _loadSavedQuantities();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {
        _quantities = _cartService.getCartForStore(widget.store.id);
      });
    }
  }

  Future<void> _loadSavedQuantities() async {
    await _cartService.loadCart(widget.store.id);
    if (mounted) {
      setState(() {
        _quantities = _cartService.getCartForStore(widget.store.id);
      });
    }
  }

  void _updateQuantity(String productId, int change) {
    final currentQty = _quantities[productId] ?? 0;
    final newQty = (currentQty + change).clamp(0, 999);

    // Use the service to update
    _cartService.updateQuantity(widget.store.id, productId, newQty);

    // No need to setState here as the listener will handle it
  }

  double get totalPrice {
    double sum = 0;
    for (final product in filteredProducts) {
      final qty = _quantities[product.id] ?? 0;
      if (qty > 0) {
        final price = product.priceAfterDiscount;
        sum += price * qty;
      }
    }
    return sum;
  }

  double get totalSaved {
    double sum = 0;
    for (final product in filteredProducts) {
      final qty = _quantities[product.id] ?? 0;
      if (qty > 0 && product.discount > 0) {
        final original = product.price;
        final discounted = product.priceAfterDiscount;
        sum += (original - discounted) * qty;
      }
    }
    return sum;
  }

  int get totalItems => _quantities.values.fold(0, (a, b) => a + b);

  Future<void> loadProducts() async {
    try {
      final data = await _productService.fetchProducts();
      products = data.where((p) => p.store == widget.store.id).toList();

      final catSet = <String>{"All"};
      for (var p in products) {
        if (p.categoryName.isNotEmpty) catSet.add(p.categoryName);
      }
      categories = catSet.toList();

      filterProducts(0);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(int index) {
    setState(() {
      selectedIndex = index;

      if (categories[index] == "All") {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products
            .where((p) => p.categoryName == categories[index])
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final distance = LocationUtils.getDistanceKm(store: widget.store);
    final deliveryFee = LocationUtils.getDeliveryFee(store: widget.store);

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
      body: isLoading
          ? const RestaurantShimmer()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Store Banner
                      Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 230,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: widget.store.imageUrl.isNotEmpty
                                  ? Image.network(
                                      widget.store.imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(color: Colors.grey[200]),
                            ),
                          ),
                        ],
                      ),
                      // Rating, Distance, Delivery Fee
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.blue, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              widget.store.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 24),
                            Icon(
                              Icons.location_on,
                              size: 24,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 24),
                            Icon(
                              Icons.local_shipping,
                              size: 24,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              deliveryFee,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      // Store Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: widget.store.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.store.imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.store.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.store.storeCategory.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Categories
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedIndex;
                            return GestureDetector(
                              onTap: () => filterProducts(index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF94D2FF)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  categories[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Grid/List toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${categories[selectedIndex]} (${filteredProducts.length})",
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(
                                isGridMode ? Icons.grid_view : Icons.list,
                              ),
                              onPressed: () {
                                setState(() => isGridMode = !isGridMode);
                              },
                            ),
                          ],
                        ),
                      ),
                      // Products
                      if (isGridMode)
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          itemCount: filteredProducts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.82,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, index) {
                            final item = filteredProducts[index];
                            final qty = _quantities[item.id] ?? 0;

                            return CardGrid(
                              title: item.name,
                              imgUrl: item.imageUrl,
                              isFav: false,
                              sold: 0,
                              liked: 0,
                              limitPurchase: 10,
                              originalPrice: item.price,
                              price: item.price,
                              priceAfterDis: item.priceAfterDiscount,
                              dis: item.discount,
                              quantity: qty,
                              showQtySelector: true,
                              onCardTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailScreen(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              onAdd: () => _updateQuantity(item.id, 1),
                              onRemove: () => _updateQuantity(item.id, -1),
                            );
                          },
                        )
                      else
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final item = filteredProducts[index];
                            final qty = _quantities[item.id] ?? 0;

                            return CardList(
                              title: item.name,
                              imgUrl: item.imageUrl,
                              isFav: false,
                              sold: 0,
                              liked: 0,
                              limitPurchase: 10,
                              originalPrice: item.price,
                              price: item.price,
                              priceAfterDis: item.priceAfterDiscount,
                              dis: item.discount,
                              quantity: qty,
                              onAdd: () => _updateQuantity(item.id, 1),
                              onRemove: () => _updateQuantity(item.id, -1),
                              onTapCard: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ItemDetailScreen(item: item),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
                // Bottom summary
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SummaryTotalWidget(
                    totalPrice: totalPrice,
                    totalSave: totalSaved,
                    qty: totalItems,
                    onOrder: totalItems > 0
                        ? () {
                            final cartItems = <Product, int>{};

                            for (var product in filteredProducts) {
                              final qty = _quantities[product.id] ?? 0;
                              if (qty > 0) {
                                cartItems[product] = qty;
                              }
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfirmOrderScreen(
                                  items: cartItems,
                                  subTotal: totalPrice,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

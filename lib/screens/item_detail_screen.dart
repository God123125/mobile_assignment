import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/auth/feedback_model.dart';
import 'package:khmer_cultur_app/models/product_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/confirm_order_screen.dart';
import 'package:khmer_cultur_app/screens/restaurant_screen.dart';
import 'package:khmer_cultur_app/services/cart_storage_service.dart';
import 'package:khmer_cultur_app/services/faverite_service.dart';
import 'package:khmer_cultur_app/services/feedback_service.dart';
import 'package:khmer_cultur_app/services/product_service.dart';
import 'package:khmer_cultur_app/services/store_service.dart';
import 'package:khmer_cultur_app/shimmer_loading/detail_item_shimmer.dart';
import 'package:khmer_cultur_app/utils/location_util.dart';
import 'package:khmer_cultur_app/widgets/summary_total_widget.dart';

class ItemDetailScreen extends StatefulWidget {
  final Product item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool isFavorite = false;
  final _favService = FavoriteService();
  final StoreService _storeService = StoreService();
  final CartStorageService _cartService =
      CartStorageService(); // Use the same service
  Store? store;

  int qty = 0;
  double? userLat;
  double? userLon;
  bool isLocationLoading = true;
  final FeedbackService _feedbackService = FeedbackService();
  List<FeedbackModel> feedbacks = [];
  bool isFeedbackLoading = true;
  bool showQtySelector = false;
  List<Product> _storeProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadStore();
    _loadCartAndProducts();

    // Add listener for cart changes
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
        qty = _cartService.getQuantity(widget.item.store, widget.item.id);
        showQtySelector = qty > 0;
      });
    }
  }

  Future<void> _loadCartAndProducts() async {
    // Load all cart quantities for this store
    await _cartService.loadCart(widget.item.store);

    // Load all products of this store (needed to compute total price & save)
    final allProducts = await ProductService().fetchProducts();
    final storeProducts = allProducts
        .where((p) => p.store == widget.item.store)
        .toList();

    if (!mounted) return;
    setState(() {
      _storeProducts = storeProducts;
      qty = _cartService.getQuantity(widget.item.store, widget.item.id);
      showQtySelector = qty > 0;
    });
  }

  void increaseQty() {
    _cartService.updateQuantity(widget.item.store, widget.item.id, qty + 1);
    // No need to setState here as the listener will handle it
  }

  void decreaseQty() {
    if (qty > 1) {
      _cartService.updateQuantity(widget.item.store, widget.item.id, qty - 1);
    } else {
      _cartService.updateQuantity(widget.item.store, widget.item.id, 0);
    }
    // No need to setState here as the listener will handle it
  }

  double get totalPrice {
    double sum = 0;
    final cart = _cartService.getCartForStore(widget.item.store);
    cart.forEach((id, qty) {
      final product = _storeProducts.firstWhere(
        (p) => p.id == id,
        orElse: () => widget.item,
      );
      sum += product.priceAfterDiscount * qty;
    });
    return sum;
  }

  double get totalSaved {
    double sum = 0;
    final cart = _cartService.getCartForStore(widget.item.store);
    cart.forEach((id, qty) {
      final product = _storeProducts.firstWhere(
        (p) => p.id == id,
        orElse: () => widget.item,
      );
      sum += (product.price - product.priceAfterDiscount) * qty;
    });
    return sum;
  }

  int get totalItems {
    return _cartService.getTotalItems(widget.item.store);
  }

  Future<void> _loadFeedback() async {
    if (store == null) return;

    try {
      final data = await _feedbackService.fetchFeedbacks(store!.id);

      if (mounted) {
        setState(() {
          feedbacks = data;
          isFeedbackLoading = false;
        });
      }
    } catch (e) {
      setState(() => isFeedbackLoading = false);
    }
  }

  Future<void> _loadStore() async {
    final stores = await _storeService.fetchStores();

    final found = stores.firstWhere(
      (s) => s.id == widget.item.store,
      orElse: () => stores.first,
    );

    if (mounted) {
      setState(() {
        store = found;
      });

      _loadFeedback(); // load feedback after store found
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final fav = await _favService.isFavorite(widget.item.id);
    if (mounted) {
      setState(() => isFavorite = fav);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => isFavorite = !isFavorite);
    await _favService.toggleFavorite(widget.item.id, isFavorite);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? "Added to favorites" : "Removed from favorites",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget ingredient(String title, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildFeedbackSection() {
    if (isFeedbackLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feedbacks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("No reviews yet"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final fb = feedbacks[index];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER PROFILE
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(fb.userProfile ?? ""),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USERNAME + STAR
                  Row(
                    children: [
                      Text(
                        fb.user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Text("${fb.star}"),
                    ],
                  ),
                  SizedBox(height: 2),

                  /// DESCRIPTION
                  Text(fb.description),

                  /// IMAGE
                  if (fb.feedbackImg != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fb.feedbackImg!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 5),

                  /// DATE
                  Text(
                    fb.createdAt.toString().substring(0, 10),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    if (isFeedbackLoading || store == null) {
      return const ItemDetailShimmer();
    }
    final distance = LocationUtils.getDistanceKm(store: store!);
    final deliveryFee = LocationUtils.getDeliveryFee(store: store!);

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
      ),
      body: Stack(
        children: [
          Column(
            children: [
              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                item.imageUrl,
                                height: 320,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              Positioned(
                                top: 40,
                                left: 16,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                              //buttom faverite
                              Positioned(
                                top: 40,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                      "Favorite icon tapped!",
                                    ); // <-- debug print
                                    _toggleFavorite(); // your existing function
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// ITEM NAME
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              right: 10,
                              left: 10,
                            ),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "\$${item.priceAfterDiscount}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "\$${item.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                if (item.discount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "-${item.discount.toStringAsFixed(0)}%",
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          /// STORE INFO
                          if (store != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to RestaurantScreen and pass the store
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantScreen(store: store!),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        store!.imageUrl,
                                      ),
                                      onBackgroundImageError: (_, _) {},
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            store!.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            store!.merchant.address,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    qty > 0
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              /// MINUS
                                              GestureDetector(
                                                onTap: decreaseQty,
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Text(
                                                  qty.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              /// PLUS
                                              GestureDetector(
                                                onTap: increaseQty,
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: increaseQty,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                right: 10,
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(store!.rating.toStringAsFixed(1)),

                                  const SizedBox(width: 16),

                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(distance),

                                  const SizedBox(width: 16),

                                  const Icon(
                                    Icons.local_shipping,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    deliveryFee,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      Divider(color: Colors.grey.shade100, height: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          /// FEEDBACK LIST
                          buildFeedbackSection(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom summary
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SummaryTotalWidget(
              qty: totalItems,
              totalPrice: totalPrice,
              totalSave: totalSaved,
              onOrder: totalItems > 0
                  ? () {
                      final cartItems = <Product, int>{};
                      for (var product in _storeProducts) {
                        final productQty = _cartService.getQuantity(
                          widget.item.store,
                          product.id,
                        );
                        if (productQty > 0) {
                          cartItems[product] = productQty;
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
    );
  }
}

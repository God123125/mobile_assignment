import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/auth/order_model.dart';
import 'package:khmer_cultur_app/models/product_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';
import 'package:khmer_cultur_app/screens/address_screen.dart';
import 'package:khmer_cultur_app/screens/done_screen.dart';
import 'package:khmer_cultur_app/screens/payment_screen.dart';
import 'package:khmer_cultur_app/services/address_service.dart';
import 'package:khmer_cultur_app/services/cart_storage_service.dart';
import 'package:khmer_cultur_app/services/order_service.dart';
import 'package:khmer_cultur_app/services/store_service.dart';
import 'package:khmer_cultur_app/utils/location_util.dart';
import 'package:khmer_cultur_app/widgets/summary_total_widget.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final Map<Product, int> items;
  final double subTotal;

  const ConfirmOrderScreen({
    super.key,
    required this.items,
    required this.subTotal,
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  String paymentMethod = "Cash On Delivery";
  String address = "Select Address";
  Store? store;
  double deliveryFee = 0.0;
  double discount = 0.0;
  String remark = "";
  List<Product> get filteredProducts => widget.items.keys.toList();
  String estimatedTime = "";
  String distance = "";
  bool isLoadingLocation = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadStore();
    _loadDefaultAddress();
  }

  Future<void> _submitOrder() async {
    setState(() => isSubmitting = true);

    final token = await UserSession.getToken();
    if (token == null) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    if (store == null) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Store information not loaded")),
      );
      return;
    }

    // Get saved latitude & longitude from storage
    final lat = await AddressStorageService.getSelectedLat();
    final lon = await AddressStorageService.getSelectedLon();

    if (lat == null || lon == null) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select delivery address")),
      );
      return;
    }

    // Map cart items to OrderProduct
    final products = widget.items.entries.map((entry) {
      final product = entry.key;
      final qty = entry.value;
      return OrderProduct(
        name: product.name,
        qty: qty,
        price: product.priceAfterDiscount,
        store: product.store,
        imageUrl: product.imageUrl,
        subtotal: product.priceAfterDiscount * qty,
      );
    }).toList();

    // Build the order
    final order = OrderRequest(
      deliveryFee: deliveryFee,
      paymentMethod: paymentMethod.toLowerCase() == "cash on delivery"
          ? "cash"
          : "online",
      products: products,
      remark: remark.isNotEmpty ? remark : null,
      estimatedDeliveryTime: estimatedTime,
      totalDiscount: totalSaved > 0 ? totalSaved : 0,
      latitude: lat,
      longitude: lon,
    );

    try {
      final success = await OrderService().checkout(order);

      if (!mounted) return;
      setState(() => isSubmitting = false);

      if (success) {
        await CartStorageService.clearAllCarts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order placed successfully 🎉"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DoneScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to place order ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      print("Order submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to place order ❌"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double get totalSaved {
    double sum = 0;
    for (final product in filteredProducts) {
      final qty = widget.items[product] ?? 0; // use the actual quantity in cart
      if (qty > 0 && product.discount > 0) {
        sum += (product.price - product.priceAfterDiscount) * qty;
      }
    }
    return sum;
  }

  int get totalItems {
    int sum = 0;
    for (final qty in widget.items.values) {
      sum += qty;
    }
    return sum;
  }

  /// Load first saved address or first user address
  Future<void> _loadDefaultAddress() async {
    // Try to get saved address from storage
    final saved = await AddressStorageService.getSelectedAddress();
    if (saved != null) {
      setState(() {
        address = saved;
      });
      return;
    }

    // Otherwise, get the first address from the user profile
    final user = await UserSession.getCurrentUser();
    if (user != null && user.address.isNotEmpty) {
      final firstAddress = user.address[0];
      final fullAddress =
          "${firstAddress.street}, ${firstAddress.city}, ${firstAddress.province}, ${firstAddress.country}";

      // Save it to storage
      await AddressStorageService.saveSelectedAddress(
        address: fullAddress,
        lat: firstAddress.lat,
        lon: firstAddress.lng,
      );

      setState(() {
        address = fullAddress;
      });
    }
  }

  Future<void> _loadStore() async {
    if (widget.items.isEmpty) return;

    // Assuming all items are from the same store
    final storeId = widget.items.keys.first.store;
    final stores = await StoreService().fetchStores();
    final foundStore = stores.firstWhere(
      (s) => s.id == storeId,
      orElse: () => stores.first,
    );

    final lat = UserSession.getLatitude() ?? 0.0;
    final lng = UserSession.getLongitude() ?? 0.0;

    setState(() {
      store = foundStore;
      deliveryFee =
          double.tryParse(
            LocationUtils.getDeliveryFee(
              store: foundStore,
              userLat: lat,
              userLon: lng,
            ).replaceAll("\$", ""),
          ) ??
          0.0;
    });
    await _loadLocationInfo();
  }

  Future<void> _loadLocationInfo() async {
    if (!mounted) return;

    setState(() => isLoadingLocation = true);

    final time = await LocationUtils.getEstimatedTime(store: store!);
    final dist = await LocationUtils.getDistanceKm(store: store!);

    if (!mounted) return;

    setState(() {
      estimatedTime = time;
      distance = dist;
      isLoadingLocation = false;
    });
  }

  Future<void> _reloadLocationAfterAddressChange() async {
    if (store == null) return;

    final lat = await AddressStorageService.getSelectedLat();
    final lon = await AddressStorageService.getSelectedLon();

    if (lat == null || lon == null) return;

    setState(() => isLoadingLocation = true);

    // Update delivery fee
    final feeStr = LocationUtils.getDeliveryFee(
      store: store!,
      userLat: lat,
      userLon: lon,
    );
    final newFee = double.tryParse(feeStr.replaceAll("\$", "")) ?? 0.0;

    // Update distance + time
    final newDistance = await LocationUtils.getDistanceKm(
      store: store!,
      userLat: lat,
      userLon: lon,
    );

    final newTime = LocationUtils.getEstimatedTime(
      store: store!,
      userLat: lat,
      userLon: lon,
    );

    if (!mounted) return;

    setState(() {
      deliveryFee = newFee;
      distance = newDistance;
      estimatedTime = newTime;
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.subTotal + deliveryFee - totalSaved;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Confirm Order", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    /// STORE NAME
                    if (store != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.store, color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              store!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),

                    /// CART ITEMS
                    ...widget.items.entries.map((entry) {
                      final product = entry.key;
                      final qty = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${product.priceAfterDiscount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text("$qty Items"),
                          ],
                        ),
                      );
                    }),
                    if (store != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50, // soft background color
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.orange),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estimated Delivery Time",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                isLoadingLocation
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Calculating...",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "$estimatedTime • $distance",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    /// SUB TOTAL
                    _row(
                      "Sub Total",
                      "\$${widget.subTotal.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 8),

                    /// DELIVERY
                    _row("Delivery Fee", "\$${deliveryFee.toStringAsFixed(2)}"),
                    const SizedBox(height: 8),

                    /// DISCOUNT
                    _row("Discount", "-\$${totalSaved.toStringAsFixed(2)}"),
                    const SizedBox(height: 10),

                    /// TOTAL
                    _row("Total", "\$${total.toStringAsFixed(2)}", bold: true),
                    const SizedBox(height: 15),

                    /// PAYMENT METHOD ROW
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PaymentScreen(selectedMethod: paymentMethod),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            paymentMethod = result;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Payment Method",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text(
                                  paymentMethod,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 5),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// ADDRESS ROW
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddressScreen(),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            address = result;
                          });
                          await _reloadLocationAfterAddressChange();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "Delivery Address",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                address,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// REMARK TEXT FIELD
                    TextField(
                      maxLines: 3,
                      onChanged: (val) {
                        setState(() {
                          remark = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Add a remark for the order",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),

                    const SizedBox(
                      height: 120,
                    ), // extra space for bottom widget
                  ],
                ),
              ),
            ],
          ),

          /// BOTTOM SUMMARY WIDGET
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SummaryTotalWidget(
              totalPrice: total,
              totalSave: totalSaved,
              qty: widget.items.values.fold(0, (p, e) => p + e),
              onOrder: widget.items.isNotEmpty && !isSubmitting
                  ? () {
                      _submitOrder();
                    }
                  : null,
              isLoading: isSubmitting, // <-- add this property in your widget
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

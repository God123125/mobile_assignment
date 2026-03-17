import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/models/auth/order_model.dart';
import 'package:khmer_cultur_app/screens/cancel_screen.dart';
import 'package:khmer_cultur_app/screens/rating_screen.dart';
import 'package:khmer_cultur_app/screens/restaurant_screen.dart';
import 'package:khmer_cultur_app/screens/track_order_screen.dart';
import 'package:khmer_cultur_app/services/order_service.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late PageController _pageController;
  int _selectedTab = 0;

  final OrderService _orderService = OrderService();

  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _ordersFuture = _orderService.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SearchBox(),
            // Tabs
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Ongoing', 0),
                  SizedBox(width: 32),
                  _buildTab('History', 1),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<OrderModel>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No orders found'));
                  }

                  // Filter orders for tabs
                  final ongoing = snapshot.data!
                      .where((o) => o.status.toLowerCase() == 'pending')
                      .toList();
                  final history = snapshot.data!.where((o) {
                    final status = o.status.toLowerCase();
                    return status == 'completed' || status == 'canceled';
                  }).toList();

                  return PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    children: [
                      // Ongoing Tab
                      ongoing.isEmpty
                          ? Center(child: Text('No orders found'))
                          : _buildOngoingContentFromApi(ongoing),
                      // History Tab
                      history.isEmpty
                          ? Center(child: Text('No orders found'))
                          : _buildHistoryContentFromApi(history),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildOngoingContentFromApi(List<OrderModel> orders) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: orders.map((order) {
          return _buildOrderItemFromApi(order);
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryContentFromApi(List<OrderModel> orders) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: orders.map((order) {
          return _buildHistoryOrderItemFromApi(order);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderItemFromApi(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat('dd MMM, yyyy – HH:mm').format(order.createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order.status.toLowerCase() == 'completed'
                      ? Colors.green.shade100
                      : order.status.toLowerCase() == 'pending'
                      ? Colors.orange.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: order.status.toLowerCase() == 'completed'
                        ? Colors.green.shade800
                        : order.status.toLowerCase() == 'pending'
                        ? Colors.orange.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Store Name with Icon
          Row(
            children: [
              const Icon(Icons.store, size: 24, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (order.products.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackOrderScreen(order: order),
                        ),
                      );
                    }
                  },
                  child: Text(
                    order.products.isNotEmpty
                        ? order.products[0].store.name
                        : 'Store',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue, // indicate clickable
                      decoration: TextDecoration.underline, // optional for UX
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Products
          ...order.products.map(
            (p) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.network(
                p.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(p.name),
              subtitle: Text('${p.qty} x \$${p.price.toStringAsFixed(2)}'),
              trailing: Text('\$${(p.price * p.qty).toStringAsFixed(2)}'),
            ),
          ),

          const SizedBox(height: 8),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackOrderScreen(order: order),
                      ),
                    );

                    if (refresh == true) {
                      // Refresh orders after confirmation
                      setState(() {
                        _ordersFuture = _orderService.getOrders();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Track Order',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // When calling CancelScreen in OrderScreen:
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => CancelScreen(
                        onConfirm: () async {
                          // Call cancel API
                          await _cancelOrder(order);

                          // Refresh orders
                          setState(() {
                            _ordersFuture = _orderService.getOrders();
                          });
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOrderItemFromApi(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat('dd MMM, yyyy – HH:mm').format(order.createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order.status.toLowerCase() == 'completed'
                      ? Colors.green.shade100
                      : order.status.toLowerCase() == 'pending'
                      ? Colors.orange.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: order.status.toLowerCase() == 'completed'
                        ? Colors.green.shade800
                        : order.status.toLowerCase() == 'pending'
                        ? Colors.orange.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Store Name with Icon
          Row(
            children: [
              const Icon(Icons.store, size: 24, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (order.products.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackOrderScreen(order: order),
                        ),
                      );
                    }
                  },
                  child: Text(
                    order.products.isNotEmpty
                        ? order.products[0].store.name
                        : 'Store',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue, // indicate clickable
                      decoration: TextDecoration.underline, // optional for UX
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Product List
          ...order.products.map(
            (p) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.network(
                p.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(p.name),
              subtitle: Text('${p.qty} x \$${p.price.toStringAsFixed(2)}'),
              trailing: Text('\$${(p.price * p.qty).toStringAsFixed(2)}'),
            ),
          ),

          const SizedBox(height: 8),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => const RatingScreen(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Rate',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(width: 12),
              if (order.products.isNotEmpty)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => RestaurantScreen(store: order.products[0].store),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Re-Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 2,
            width: label.length * 10.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(OrderModel order) async {
    setState(() {});

    try {
      // Direct API call without service
      final url = ApiEndpoints.confirmOrder(order.id);
      final response = await _orderService.patch(
        url,
        body: {'isConfirmOrder': false},
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order canceled successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Refresh order list
        setState(() {
          _ordersFuture = _orderService.getOrders();
        });

        // Close Cancel dialog
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel order: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {});
    }
  }
}

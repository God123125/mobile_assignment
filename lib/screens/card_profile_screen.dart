import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class CartProfileScreen extends StatefulWidget {
  const CartProfileScreen({super.key});

  @override
  State<CartProfileScreen> createState() => _CartProfileScreenState();
}

class _CartProfileScreenState extends State<CartProfileScreen> {
  bool _selectAll = false;
  double _total = 7.30;

  final List<Map<String, dynamic>> _cartItems = [
    {
      'image': 'assets/images/welcom1.png',
      'name': 'នំបញ្ចុកសម្លរខ្មែរ',
      'price': 1.50,
      'size': 'M',
      'quantity': 2,
    },
    {
      'image': 'assets/images/welcom2.png',
      'name': 'បំពង់ដាក់ទឹក',
      'price': 2.15,
      'size': 'S',
      'quantity': 1,
    },
  ];

  void _updateQuantity(int index, int change) {
    setState(() {
      _cartItems[index]['quantity'] = (_cartItems[index]['quantity'] + change).clamp(1, 999);
      _calculateTotal();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _total = _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Color(0xFF2C2C2C), size: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  // Title
                  Expanded(
                    child: Text(
                      "Cart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                  // Done Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "DONE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: _cartItems.isEmpty
                  ? Center(
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return _buildCartItem(item, index);
                      },
                    ),
            ),

            // Footer Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Column(
                children: [
                  // Select All and Total Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _selectAll,
                            onChanged: (value) {
                              setState(() {
                                _selectAll = value ?? false;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Text("All", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "TOTAL: ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$${_total.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle checkout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        "CHECKOUT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12),
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                SizedBox(height: 4),
                // Price
                Text(
                  "\$${item['price'].toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
                ),
                SizedBox(height: 4),
                // Size
                Text(item['size'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          // Remove Button and Quantity Controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Remove Button
              GestureDetector(
                onTap: () {
                  _removeItem(index);
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
              SizedBox(height: 8),
              // Quantity Controls
              Row(
                children: [
                  // Minus Button
                  GestureDetector(
                    onTap: () {
                      _updateQuantity(index, -1);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove, color: Color(0xFF2C2C2C), size: 18),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Quantity
                  Text(
                    "${item['quantity']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Plus Button
                  GestureDetector(
                    onTap: () {
                      _updateQuantity(index, 1);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Color(0xFF2C2C2C), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

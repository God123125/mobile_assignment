import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:khmer_cultur_app/widgets/search_box_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTab = 1; // 0 for Ongoing, 1 for History (default to History)

  // Sample data - Food orders (Completed)
  final List<Map<String, dynamic>> foodOrders = [
    {
      'name': 'នំបញ្ចុក',
      'price': '1.50',
      'date': '29 JAN, 12:30',
      'itemCount': '03 Items',
      'orderId': '#162432',
      'image': 'assets/images/welcom1.png',
      'status': 'Completed',
    },
  ];

  // Sample data - Product orders (Completed)
  final List<Map<String, dynamic>> productOrders = [
    {
      'name': 'កំប៉ុងដាក់ទឹក',
      'price': '2.15',
      'date': '30 JAN, 12:30',
      'itemCount': '02 Items',
      'orderId': '#242432',
      'image': 'assets/images/welcom2.png',
      'status': 'Completed',
    },
  ];

  // Sample data - Drink orders (Canceled)
  final List<Map<String, dynamic>> drinkOrders = [
    {
      'name': 'Hol Pos',
      'price': '10.20',
      'date': '30 JAN, 12:30',
      'itemCount': '01 Items',
      'orderId': '#240112',
      'image': 'assets/images/welcom3.png',
      'status': 'Canceled',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, automaticallyImplyLeading: false),
      body: Column(
        children: [
          SearchBox(),
          // Tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildTab('Ongoing', 0), SizedBox(width: 32), _buildTab('History', 1)],
            ),
          ),
          SizedBox(height: 16),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Section
                  _buildSectionHeader('Food', 'Completed'),
                  SizedBox(height: 12),
                  ...foodOrders.map((order) => _buildHistoryOrderItem(order)),
                  SizedBox(height: 24),
                  // Product Section
                  _buildSectionHeader('Product', 'Completed'),
                  SizedBox(height: 12),
                  ...productOrders.map((order) => _buildHistoryOrderItem(order)),
                  SizedBox(height: 24),
                  // Drink Section
                  _buildSectionHeader('Drink', 'Canceled'),
                  SizedBox(height: 12),
                  ...drinkOrders.map((order) => _buildHistoryOrderItem(order)),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Navigate back to Ongoing screen
          Navigator.pop(context);
        } else {
          setState(() {
            _selectedTab = index;
          });
        }
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

  Widget _buildSectionHeader(String title, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: status == 'Completed' ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryOrderItem(Map<String, dynamic> order) {
    final isCanceled = order['status'] == 'Canceled';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    order['image'],
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
              // Name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${order['price']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          order['date'],
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        SizedBox(width: 8),
                        Container(width: 1, height: 14, color: Colors.grey.shade300),
                        SizedBox(width: 8),
                        Text(
                          order['itemCount'],
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Order ID
              GestureDetector(
                onTap: () {
                  // Handle order ID tap
                },
                child: Text(
                  order['orderId'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Buttons or Canceled status
          if (isCanceled)
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Center(
                child: Text(
                  'Canceled',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle Rate
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Rate',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Re-Order
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Re-Order',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

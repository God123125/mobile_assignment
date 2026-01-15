import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

// Custom painter for the curved orange path line
// class TrackingPathPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.orange
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     // Starting point (center of the white dot)
//     final startPoint = Offset(size.width * 0.75, size.height * 0.45);
//     // End point (downwards and slightly to the left)
//     final endPoint = Offset(size.width * 0.65, size.height * 0.75);

//     // Create a curved path
//     final path = Path();
//     path.moveTo(startPoint.dx, startPoint.dy);

//     // Create a quadratic bezier curve for smooth curved line
//     final controlPoint = Offset(
//       (startPoint.dx + endPoint.dx) / 2,
//       startPoint.dy + (endPoint.dy - startPoint.dy) * 0.6,
//     );
//     path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chevron_left, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Map-like visualization area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/order_track.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Custom paint for the curved orange path
                    // CustomPaint(size: Size.infinite, painter: TrackingPathPainter()),
                    // Orange tracking marker (multi-layered circles)
                    // Positioned(
                    //   right: 40,
                    //   top: 80,
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       // Outer glowing ring
                    //       Container(
                    //         width: 70,
                    //         height: 70,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: Colors.orange.withOpacity(0.15),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.orange.withOpacity(0.3),
                    //               blurRadius: 25,
                    //               spreadRadius: 15,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       // Solid orange circle
                    //       Container(
                    //         width: 56,
                    //         height: 56,
                    //         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
                    //       ),
                    //       // Lighter orange/yellow circle
                    //       Container(
                    //         width: 36,
                    //         height: 36,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: Colors.orange.shade300,
                    //         ),
                    //       ),
                    //       // White center dot
                    //       Container(
                    //         width: 12,
                    //         height: 12,
                    //         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // Order Details Card (no scroll, compact)
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant Information
                      Row(
                        children: [
                          // Restaurant icon
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 1.5),
                            ),
                            child: Icon(Icons.restaurant, color: Colors.red, size: 16),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nita House Food',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  'Orderd At 06 Sept, 10:00pm',
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Ordered Items
                      Text(
                        '3x នំបញ្ចុក',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '2x កំប៉ុងដាក់ទឹក',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                      ),
                      SizedBox(height: 10),
                      // Estimated Delivery Time
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '20 min',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'ESTIMATED DELIVERY TIME',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      // Status Timeline
                      _buildTimelineItem(
                        isCompleted: true,
                        isActive: false,
                        icon: Icons.check,
                        title: 'Your order has been received',
                      ),
                      SizedBox(height: 10),
                      _buildTimelineItem(
                        isCompleted: false,
                        isActive: true,
                        icon: Icons.ac_unit,
                        title: 'The restaurant is preparing your food',
                      ),
                      SizedBox(height: 10),
                      _buildTimelineItem(
                        isCompleted: false,
                        isActive: false,
                        icon: Icons.check,
                        title: 'Your order has been picked up for delivery',
                      ),
                      SizedBox(height: 10),
                      _buildTimelineItem(
                        isCompleted: false,
                        isActive: false,
                        icon: Icons.check,
                        title: 'Order arriving soon!',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTimelineItem({
    required bool isCompleted,
    required bool isActive,
    required IconData icon,
    required String title,
    bool isLast = false,
  }) {
    final circleColor = isCompleted || isActive ? Colors.blue : Colors.grey.shade400;
    final textColor = isCompleted ? Colors.blue : Colors.grey.shade600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and icon
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: Colors.grey.shade300,
                margin: EdgeInsets.only(top: 2),
              ),
          ],
        ),
        SizedBox(width: 10),
        // Title
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

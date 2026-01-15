import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'avatar': 'assets/images/welcom1.png',
      'name': 'ផ្ទះអ្នកសៀមរាប',
      'lastMessage': 'Thank for your feedback we will review it.',
      'time': '20 min ago',
      'unreadCount': 2,
      'isRead': false,
    },
    {
      'avatar': 'assets/images/welcom2.png',
      'name': 'Restaurant Support',
      'lastMessage': 'Your order has been confirmed',
      'time': '1 hour ago',
      'unreadCount': 0,
      'isRead': true,
    },
    {
      'avatar': 'assets/images/welcom3.png',
      'name': 'Delivery Team',
      'lastMessage': 'Your order is on the way',
      'time': '2 hours ago',
      'unreadCount': 1,
      'isRead': false,
    },
    {
      'avatar': 'assets/images/welcom1.png',
      'name': 'Customer Service',
      'lastMessage': 'How can we help you today?',
      'time': '3 hours ago',
      'unreadCount': 0,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),
            // Messages List
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        "No messages",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageItem(message, index);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C), size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2C2C2C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, int index) {
    final bool hasUnread = message['unreadCount'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Handle message tap - navigate to chat detail
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with unread indicator
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      message['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          message['unreadCount'].toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500,
                            color: const Color(0xFF2C2C2C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        message['time'],
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['lastMessage'],
                    style: TextStyle(
                      fontSize: 14,
                      color: hasUnread ? Colors.grey.shade800 : Colors.grey.shade600,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTabIndex = 0; // 0 = Notifications, 1 = Messages

  final List<Map<String, dynamic>> _notifications = List.generate(
    4,
    (index) => {
      'avatar': 'assets/images/welcom1.png',
      'image': 'assets/images/welcom1.png',
      'title': 'ផ្ទះអ្នកសៀមរាប: Thank for your feedback we will review it.',
      // 'subtitle': 'feedback we will review it.',
      'time': '20 min ago',
    },
  );

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
            _buildHeader(context),
            _buildTabs(),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildNotificationsList()
                  : _buildMessagesList(),
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
          Expanded(
            child: Text(
              _selectedTabIndex == 0 ? 'Notifications' : 'Messages',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2C2C2C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabButton(
            label: 'Notifications',
            isSelected: _selectedTabIndex == 0,
            onTap: () {
              setState(() {
                _selectedTabIndex = 0;
              });
            },
          ),
          const SizedBox(width: 24),
          _buildTabButton(
            label: 'Messages (3)',
            isSelected: _selectedTabIndex == 1,
            onTap: () {
              setState(() {
                _selectedTabIndex = 1;
              });
            },
            isSecondary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    final Color activeColor = Colors.blue;
    final Color textColor = isSelected ? activeColor : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: isSecondary ? 90 : 100,
            height: 2,
            color: isSelected ? activeColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final item = _notifications[index];
        return _buildNotificationItem(item);
      },
    );
  }

  Widget _buildMessagesList() {
    return _messages.isEmpty
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
          );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(
                item['avatar'],
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
          const SizedBox(width: 12),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      // const TextSpan(text: ' '),
                      // TextSpan(
                      //   text: item['subtitle'],
                      //   style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(item['time'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right image
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
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

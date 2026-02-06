import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isAdmin; // true if current user is admin, false if customer
  final bool isConversationWithAdmin; // true if the other person is admin

  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.isAdmin = false, // Default to customer view
    this.isConversationWithAdmin = false,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample conversation between admin and customer
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'text': 'Thank for your feedback we will review it.',
      'sender': 'admin', // 'admin' or 'customer'
      'time': '20 min ago',
    },
    {
      'text': 'Hello, I have a question about my order.',
      'sender': 'customer',
      'time': '25 min ago',
    },
    {'text': 'How can I track my order?', 'sender': 'customer', 'time': '30 min ago'},
    {
      'text':
          'You can track your order in the Order section. Your order #240112 is being prepared.',
      'sender': 'admin',
      'time': '35 min ago',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _chatMessages.insert(0, {
        'text': _messageController.text.trim(),
        'sender': widget.isAdmin ? 'admin' : 'customer',
        'time': 'Just now',
      });
      _messageController.clear();
    });

    // Auto scroll to top (newest message)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Messages List
            Expanded(
              child: _chatMessages.isEmpty
                  ? Center(
                      child: Text(
                        "No messages yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: _chatMessages.length,
                      itemBuilder: (context, index) {
                        final message = _chatMessages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
            // Input Section
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
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
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(
                widget.userAvatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey, size: 20),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                Text('Online', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final String sender = message['sender'] as String;
    final bool isCurrentUser =
        (widget.isAdmin && sender == 'admin') || (!widget.isAdmin && sender == 'customer');
    final bool isAdminMessage = sender == 'admin';

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender label (only for received messages)
            if (!isCurrentUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text(
                  isAdminMessage ? 'Admin' : 'Customer',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? Colors.blue
                    : (isAdminMessage ? Colors.green.shade50 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(18),
                border: isAdminMessage && !isCurrentUser
                    ? Border.all(color: Colors.green.shade300, width: 1)
                    : null,
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  fontSize: 14,
                  color: isCurrentUser
                      ? Colors.white
                      : (isAdminMessage ? Colors.green.shade900 : const Color(0xFF2C2C2C)),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(right: isCurrentUser ? 8 : 0, left: isCurrentUser ? 0 : 8),
              child: Text(
                message['time'],
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          // Text Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

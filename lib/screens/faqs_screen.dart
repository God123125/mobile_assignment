import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I place an order?',
      'answer':
          'You can place an order by browsing our menu, selecting items, and adding them to your cart. Then proceed to checkout and complete your payment. You can track your order status in real-time through the Order section.',
      'isExpanded': false,
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept various payment methods including cash on delivery, credit/debit cards, and mobile payment options. You can choose your preferred method during checkout. All transactions are secure and encrypted.',
      'isExpanded': false,
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'You can track your order in the Order section of the app. You will receive real-time updates about your order status including preparation, cooking, and delivery. You will also receive notifications when your order status changes.',
      'isExpanded': false,
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'Yes, you can cancel your order if it hasn\'t been prepared yet. Go to the Order section, select your order, and choose the cancel option. Once the order is being prepared, cancellation may not be possible. Please contact customer service for assistance.',
      'isExpanded': false,
    },
    {
      'question': 'How long does delivery take?',
      'answer':
          'Delivery time varies depending on your location and order size. Typically, orders are delivered within 30-60 minutes. You can see estimated delivery time during checkout. You will receive updates if there are any delays.',
      'isExpanded': false,
    },
    {
      'question': 'What if I have dietary restrictions?',
      'answer':
          'We offer various options for different dietary needs. You can filter items by dietary preferences in the menu section. Please contact us if you have specific requirements, and we will do our best to accommodate your needs.',
      'isExpanded': false,
    },
    {
      'question': 'How do I update my delivery address?',
      'answer':
          'You can update your delivery address by going to Profile > Addresses. You can add, edit, or delete addresses from there. Make sure to set a default address for faster checkout.',
      'isExpanded': false,
    },
    {
      'question': 'Do you offer refunds?',
      'answer':
          'Refunds are available for orders that haven\'t been prepared or in case of issues with your order. Please contact our customer service for assistance. Refunds will be processed to your original payment method within 5-7 business days.',
      'isExpanded': false,
    },
    {
      'question': 'How do I contact customer service?',
      'answer':
          'You can contact our customer service through the Messages section in your profile. Our support team is available 24/7 to assist you with any questions or concerns. You can also reach us via email or phone.',
      'isExpanded': false,
    },
    {
      'question': 'Can I modify my order after placing it?',
      'answer':
          'You can modify your order only if it hasn\'t been prepared yet. Go to the Order section, select your order, and choose the modify option. For orders that are already being prepared, please contact customer service immediately.',
      'isExpanded': false,
    },
  ];

  void _toggleExpansion(int index) {
    setState(() {
      _faqs[index]['isExpanded'] = !_faqs[index]['isExpanded'];
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'FAQs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // FAQs List
            Expanded(
              child: _faqs.isEmpty
                  ? Center(
                      child: Text(
                        'No FAQs available',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _faqs.length,
                      itemBuilder: (context, index) {
                        final faq = _faqs[index];
                        final isExpanded = faq['isExpanded'] as bool;
                        return _buildFAQItem(
                          question: faq['question'] as String,
                          answer: faq['answer'] as String,
                          isExpanded: isExpanded,
                          onTap: () => _toggleExpansion(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 12),
                  Text(
                    answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}



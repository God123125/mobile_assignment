
import 'package:flutter/material.dart';

class CardGrid extends StatelessWidget {
  // ← change to Stateless
  final String title;
  final String imgUrl;
  final bool isFav;
  final int sold;
  final int liked;
  final int limitPurchase;
  final double originalPrice;
  final double? price;
  final double? priceAfterDis;
  final double? dis;
  final int quantity; // ← renamed
  final bool showQtySelector;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onCardTap;

  const CardGrid({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.isFav,
    required this.sold,
    required this.liked,
    required this.limitPurchase,
    required this.originalPrice,
    this.price,
    this.priceAfterDis,
    this.dis,
    this.quantity = 0,
    this.showQtySelector = true,
    required this.onAdd,
    required this.onRemove,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = (dis ?? 0) > 0;

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(22, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          image: NetworkImage(imgUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$sold+ sold • $liked liked",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "• Limit purchase $limitPurchase",
                        style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                      ),
                      if (hasDiscount)
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "-${dis!.toStringAsFixed(0)}%",
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price + Quantity control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasDiscount) ...[
                            Text(
                              "\$${priceAfterDis!.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "\$${price!.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13,
                              ),
                            ),
                          ] else
                            Text(
                              "\$${price!.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                        ],
                      ),

                      if (quantity == 0)
                        // Show only + button when quantity is 0
                        _buildAddButton()
                      else
                        // Show full - qty + controls when quantity > 0
                        _buildQuantitySelector(quantity),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildQuantitySelector(int qty) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.remove, color: Colors.white, size: 22),
          ),
        ),
        Container(
          width: 30, // fixed width for number
          alignment: Alignment.center,
          child: Text(
            "$qty",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}

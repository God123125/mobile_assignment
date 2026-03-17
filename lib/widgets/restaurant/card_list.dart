import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
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
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTapCard; // renamed for clarity

  const CardList({
    super.key,
    required this.title,
    required this.imgUrl,
    this.isFav = false,
    this.sold = 0,
    this.liked = 0,
    this.limitPurchase = 10,
    required this.originalPrice,
    this.price,
    this.priceAfterDis,
    this.dis,
    this.quantity = 0,
    required this.onAdd,
    required this.onRemove,
    required this.onTapCard,
  });

  bool get hasDiscount => (dis ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    final displayPrice = hasDiscount ? priceAfterDis ?? price : price;
    final strikePrice = hasDiscount ? price : null;

    return GestureDetector(
      onTap: onTapCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(35, 0, 0, 0),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image + favorite
              Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(imgUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey[400],
                      size: 26,
                    ),
                  ),
                ],
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),

                      // Sold / liked
                      Text(
                        "$sold+ sold • $liked liked",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),

                      // Limit & discount badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "• Limit purchase $limitPurchase",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (hasDiscount) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "-${dis!.toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Price + Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "\$${displayPrice!.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: hasDiscount
                                      ? Colors.red[700]
                                      : Colors.black87,
                                ),
                              ),
                              if (strikePrice != null) ...[
                                const SizedBox(width: 6),
                                Text(
                                  "\$${strikePrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // Quantity control (same logic as CardGrid)
                          if (quantity == 0)
                            _buildAddButton()
                          else
                            _buildQuantitySelector(quantity),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 22),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            "$qty",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}
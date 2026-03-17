import 'package:flutter/material.dart';

class CardGridHome extends StatelessWidget {
  final String title;
  final String? image;
  final double? price;
  final double? priceAfterDis;
  final double? dis;

  const CardGridHome({
    super.key,
    required this.title,
    this.image,
    this.price,
    this.priceAfterDis,
    this.dis
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(22, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: _buildImage(),
            ),
          ),

          /// TEXT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (price != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "\$${priceAfterDis!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "\$${price!.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      if (dis! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "-${dis!.toStringAsFixed(0)}%",
                          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // If null or empty → show placeholder
    if (image == null || image!.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }

    // If network image
    if (image!.startsWith("http")) {
      return Image.network(
        image!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      );
    }

    // Otherwise asset
    return Image.asset(
      image!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 40),
        );
      },
    );
  }
}

import 'package:khmer_cultur_app/models/store_model.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String categoryId;
  final String categoryName;
  final bool isActive;
  final double discount;
  final double priceAfterDiscount;
  final String store;
  Store? storeInfo;   
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.isActive,
    required this.discount,
    required this.priceAfterDiscount,
    required this.store,
    this.storeInfo,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      categoryId: json['category']?['_id'] ?? '',
      categoryName: json['category']?['name'] ?? '',
      isActive: json['isActive'] ?? false,
      discount: (json['discount'] ?? 0).toDouble(),
      priceAfterDiscount: (json['price_after_discount'] ?? 0).toDouble(),
      store: json['store'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
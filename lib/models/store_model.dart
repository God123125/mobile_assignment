class Store {
  final String id;
  final String name;
  final StoreCategory storeCategory;
  final bool isActive;
  final Merchant merchant;
  final double rating;
  final Address address;
  final bool isDeliveryFee;
  final String imageUrl;

  Store({
    required this.id,
    required this.name,
    required this.storeCategory,
    required this.isActive,
    required this.merchant,
    required this.rating,
    required this.address,
    required this.isDeliveryFee,
    required this.imageUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      storeCategory: json['store_category'] != null
          ? StoreCategory.fromJson(json['store_category'])
          : StoreCategory(
              id: '',
              name: '',
              description: '',
              imageUrl: '',
              isActive: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      isActive: json['isActive'] ?? false,
      merchant: json['merchant'] != null
          ? Merchant.fromJson(json['merchant'])
          : Merchant(
              id: '',
              fullname: '',
              username: '',
              email: '',
              phone: '',
              address: '',
              role: '',
              commissionRate: 0,
              isActive: true,
            ),
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(latitude: 0, longitude: 0),
      isDeliveryFee: json['is_delivery_fee'] ?? false,
      imageUrl: json['image_url'] ?? '',
    );
  }
}

// Nested models

class StoreCategory {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? json['des'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class Merchant {
  final String id;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final String address;
  final String role;
  final int commissionRate;
  final bool isActive;

  Merchant({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.commissionRate,
    required this.isActive,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      commissionRate: json['commission_rate'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }
}

class Address {
  final double latitude;
  final double longitude;

  Address({required this.latitude, required this.longitude});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      latitude: double.tryParse(json['latitude'].toString()) ?? 0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0,
    );
  }
}
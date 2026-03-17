import 'address_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profile;
  final List<AddressModel> address;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profile,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profile: json['profile'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      address: (json['address'] as List? ?? [])
          .map((e) => AddressModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile': profile,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'address': address.map((e) => {
        '_id': e.id,
        'street': e.street,
        'city': e.city,
        'province': e.province,
        'country': e.country,
        'lat': e.lat,
        'lng': e.lng,
      }).toList(),
    };
  }
}
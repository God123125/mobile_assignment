import 'package:khmer_cultur_app/models/auth/address_model.dart';

class PersonalInfoResponse {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<AddressModel> address;
  final String? profile;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  PersonalInfoResponse({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.address,
    this.profile,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) {
    return PersonalInfoResponse(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: (json['address'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      profile: json['profile'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address.map((e) => e.toJson()).toList(),
      'profile': profile,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}
import 'package:khmer_cultur_app/models/auth/address_model.dart';

class UpdateInfoModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<AddressModel> address; 

  UpdateInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address.map((e) => e.toJson()).toList(),
    };
  }
}

class UpdateInfoModelResponse {
  final String msg;
  final UserProfile? data;

  UpdateInfoModelResponse({required this.msg, this.data});

  factory UpdateInfoModelResponse.fromJson(Map<String, dynamic> json) {
    return UpdateInfoModelResponse(
      msg: json['msg'] as String? ?? '',
      data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'msg': msg, 'data': data?.toJson()};
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? phone;
  final List<AddressModel> address;
  final ProfilePicture? profile;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version; // __v

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.phone,
    required this.address,
    this.profile,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      address:
          (json['address'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      profile: json['profile'] != null
          ? ProfilePicture.fromJson(json['profile'])
          : null,
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
      'password': password,
      'phone': phone,
      "address": address
          .map(
            (e) => {
              '_id': e.id,
              'street': e.street,
              'city': e.city,
              'province': e.province,
              'country': e.country,
              'lat': e.lat,
              'lng': e.lng,
            },
          )
          .toList(),
      'profile': profile?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}

class ProfilePicture {
  final String filename;
  final String mimetype;
  final int length;

  ProfilePicture({
    required this.filename,
    required this.mimetype,
    required this.length,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      filename: json['filename'] as String? ?? '',
      mimetype: json['mimetype'] as String? ?? '',
      length: json['length'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'filename': filename, 'mimetype': mimetype, 'length': length};
  }
}

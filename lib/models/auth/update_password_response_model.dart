class UpdatePasswordResponse {
  final String msg;
  final UserData data;

  UpdatePasswordResponse({
    required this.msg,
    required this.data,
  });

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(
      msg: json['msg'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final List<Address> address;
  final Profile profile;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      address: (json['address'] as List<dynamic>? ?? [])
          .map((e) => Address.fromJson(e))
          .toList(),
      profile: Profile.fromJson(json['profile'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String province;
  final String country;
  final double lat;
  final double lng;
  final String id;

  Address({
    required this.street,
    required this.city,
    required this.province,
    required this.country,
    required this.lat,
    required this.lng,
    required this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      id: json['_id'] ?? '',
    );
  }
}

class Profile {
  final String filename;
  final String mimetype;
  final int length;

  Profile({
    required this.filename,
    required this.mimetype,
    required this.length,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      filename: json['filename'] ?? '',
      mimetype: json['mimetype'] ?? '',
      length: json['length'] ?? 0,
    );
  }
}

class AddressModel {
  final String id;
  final String street;
  final String city;
  final String province;
  final String country;
  final double lat;
  final double lng;

  AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.province,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }
}
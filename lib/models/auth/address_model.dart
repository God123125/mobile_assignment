// class AddressModel {
//   final String id;
//   final String street;
//   final String city;
//   final String province;
//   final String country;
//   final double lat;
//   final double lng;

//   AddressModel({
//     required this.id,
//     required this.street,
//     required this.city,
//     required this.province,
//     required this.country,
//     required this.lat,
//     required this.lng,
//   });

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       id: json['_id'] ?? '',
//       street: json['street'] ?? '',
//       city: json['city'] ?? '',
//       province: json['province'] ?? '',
//       country: json['country'] ?? '',
//       lat: (json['lat'] ?? 0).toDouble(),
//       lng: (json['lng'] ?? 0).toDouble(),
//     );
//   }
// }
class AddressModel {
  final String? id;
  final String street;
  final String city;
  final String province;
  final String country;
  final double lat;
  final double lng;

  AddressModel({
    this.id,
    required this.street,
    required this.city,
    required this.province,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] as String?,
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lng'].toString()) ?? 0.0,
    );
  }

Map<String, dynamic> toJson() {
  final map = {
    'street': street,
    'city': city,
    'province': province,
    'country': country,
    'lat': lat.toString(), // ✅ MUST be string
    'lng': lng.toString(),
  };

  if (id != null && id!.isNotEmpty) {
    map['_id'] = id!;
  }

  return map;
}
}
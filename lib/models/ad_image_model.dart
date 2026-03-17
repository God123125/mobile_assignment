class Advertising {
  final String id;
  final String description;
  final bool isActive;
  final String storeImage;
  final String adImage;
  final StoreInfo store;

  Advertising({
    required this.id,
    required this.description,
    required this.isActive,
    required this.storeImage,
    required this.adImage,
    required this.store,
  });

  factory Advertising.fromJson(Map<String, dynamic> json) {
    return Advertising(
      id: json['_id'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      storeImage: json['store_img'] ?? '',
      adImage: json['ad_img'] ?? '',
      store: StoreInfo.fromJson(json['store'] ?? {}),
    );
  }
}

class StoreInfo {
  final String id;
  final String name;

  StoreInfo({
    required this.id,
    required this.name,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
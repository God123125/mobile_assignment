// class StoreCategory {
//   final String id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final bool isActive;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   StoreCategory({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.isActive,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory StoreCategory.fromJson(Map<String, dynamic> json) {
//     return StoreCategory(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? json['des'] ?? '', // fallback if description missing
//       imageUrl: json['image_url'] ?? '',
//       isActive: json['isActive'] ?? true, // default to true if missing
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : DateTime.now(),
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'description': description,
//       'image_url': imageUrl,
//       'isActive': isActive,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
import 'package:khmer_cultur_app/models/auth/user_model.dart';

class FeedbackModel {
  final String id;
  final int star;
  final String description;
  final String? feedbackImg;
  final String? userProfile;
  final UserModel user;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.star,
    required this.description,
    this.feedbackImg,
    this.userProfile,
    required this.user,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['_id'] ?? '',
      star: json['star'] ?? 0,
      description: json['description'] ?? '',
      feedbackImg: json['feedback_img'],
      userProfile: json['user_profile'],
      user: UserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//     );
//   }
// }
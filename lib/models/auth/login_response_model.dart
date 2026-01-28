import 'user_model.dart';

class LoginResponseModel {
  UserModel user;
  String token;
  String expireAt;
  String message;

  LoginResponseModel({
    required this.user,
    required this.token,
    required this.expireAt,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
      expireAt: json['expireAt'],
      message: json['message'],
    );
  }
}

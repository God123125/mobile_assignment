class ResendVerifyModel {
  String email;

  ResendVerifyModel({required this.email});

  factory ResendVerifyModel.fromJson(Map<String, dynamic> json) {
    return ResendVerifyModel(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

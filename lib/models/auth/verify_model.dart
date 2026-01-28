class VerifyModel {
  String email;
  String code;

  VerifyModel({
    required this.email,
    required this.code,
  });

  factory VerifyModel.fromJson(Map<String, dynamic> json) {
    return VerifyModel(
      email: json['email'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}

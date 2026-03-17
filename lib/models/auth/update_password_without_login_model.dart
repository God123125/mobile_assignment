class UpdatePasswordWithoutLoginModel {
  String email;
  String code;
  String newPass;

  UpdatePasswordWithoutLoginModel({
    required this.email,
    required this.code,
    required this.newPass,
  });

  factory UpdatePasswordWithoutLoginModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordWithoutLoginModel(
      email: json['email'],
      code: json['code'],
      newPass: json['newPass'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
      'newPass': newPass
    };
  }
}

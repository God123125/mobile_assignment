class UpdatePassByOldPassModel {
  String email;
  String oldPass;
  String newPass;

  UpdatePassByOldPassModel({
    required this.email,
    required this.oldPass,
    required this.newPass,
  });

  factory UpdatePassByOldPassModel.fromJson(Map<String, dynamic> json) {
    return UpdatePassByOldPassModel(
      email: json['email'],
      oldPass: json['old_pass'],
      newPass: json['new_pass'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'old_pass': oldPass,
      'new_pass': newPass,
    };
  }
}
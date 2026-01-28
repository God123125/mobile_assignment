class RegisterModel {
  String email;
  String password;
  String name;
  String phone;

  RegisterModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    };
  }
}

class RequestToEmailModel {
  String email;

  RequestToEmailModel({required this.email});

  factory RequestToEmailModel.fromJson(Map<String, dynamic> json) {
    return RequestToEmailModel(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

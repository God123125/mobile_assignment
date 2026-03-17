class UpdatePasswordWithoutLoginReqponseModel {
  final String msg;

  UpdatePasswordWithoutLoginReqponseModel({
    required this.msg,
  });

  factory UpdatePasswordWithoutLoginReqponseModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordWithoutLoginReqponseModel(
      msg: json['msg'] ?? '',
    );
  }
}
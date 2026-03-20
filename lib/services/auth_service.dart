import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/auth/login_request_model.dart';
import 'package:khmer_cultur_app/models/auth/login_response_model.dart';
import 'package:khmer_cultur_app/models/auth/personal_infor_model.dart';
import 'package:khmer_cultur_app/models/auth/register_model.dart';
import 'package:khmer_cultur_app/models/auth/request_to_email_model.dart';
import 'package:khmer_cultur_app/models/auth/resend_verify_model.dart';
import 'package:khmer_cultur_app/models/auth/update_info_model.dart';
import 'package:khmer_cultur_app/models/auth/update_pass_by_old_pass_model.dart';
import 'package:khmer_cultur_app/models/auth/update_password_request_model.dart';
import 'package:khmer_cultur_app/models/auth/update_password_response_model.dart';
import 'package:khmer_cultur_app/models/auth/update_password_without_login_model.dart';
import 'package:khmer_cultur_app/models/auth/update_password_without_login_reqponse_model.dart';
import 'package:khmer_cultur_app/models/auth/verify_model.dart';

class AuthService extends BaseService {
  Future<bool> uploadProfileImage(File imageFile) async {
    try {
      final token = await UserSession.getToken(); // ✅ get token

      final url = Uri.parse(ApiEndpoints.updateProfile());

      var request = http.MultipartRequest('PATCH', url);

      request.files.add(
        await http.MultipartFile.fromPath('profile', imageFile.path),
      );

      // ✅ attach token
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      print("TOKEN => $token"); // 🔥 debug

      final response = await request.send();

      print("STATUS => ${response.statusCode}");

      return response.statusCode == 200;
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  Future<PersonalInfoResponse?> getPersonalInfo() async {
    try {
      final url = ApiEndpoints.getPersonalInfo;
      final response = await get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PersonalInfoResponse.fromJson(data);
      } else {
        print('Error fetching personal info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception fetching personal info: $e');
      return null;
    }
  }

  Future<UpdateInfoModelResponse?> updateUserInfo(
    UpdateInfoModel request,
  ) async {
    try {
      final url = ApiEndpoints.updateInfo();

      final body = jsonEncode(request.toJson());

      print("URL => $url");
      print("BODY => $body");

      final response = await patch(
        url,
        body: request.toJson(), // ✅ CORRECT (Map only)
      );

      print("STATUS => ${response.statusCode}");
      print("RESPONSE => ${response.body}");

      if (response.statusCode == 200) {
        return UpdateInfoModelResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("Error updating user info: $e");
      return null;
    }
  }

  /// Update password by old
  Future<UpdatePasswordWithoutLoginReqponseModel?> updatePasswordByOld(
    UpdatePassByOldPassModel request,
  ) async {
    try {
      final url = ApiEndpoints.updatePasswordByOldPass();

      print("URL => $url");
      print("BODY => ${request.toJson()}");

      final response = await patch(url, body: request.toJson());

      print("STATUS => ${response.statusCode}");
      print("RESPONSE => ${response.body}");

      if (response.statusCode == 200) {
        final data = UpdatePasswordWithoutLoginReqponseModel.fromJson(
          jsonDecode(response.body),
        );
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error updating password: $e");
      return null;
    }
  }

  //Request to email
  Future<bool> requestoEmail(RequestToEmailModel requestEmail) async {
    final url = ApiEndpoints.requestToEmail();
    final response = await post(url, body: requestEmail.toJson());

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
      return true;
    } else {
      print('Request failed: ${response.body}');
      return false;
    }
  }

  /// Update password
  Future<UpdatePasswordWithoutLoginReqponseModel?>
  updatePasswordWithoutLoginModel(
    UpdatePasswordWithoutLoginModel request,
  ) async {
    try {
      final url = ApiEndpoints.updatePasswordWithoutLoginModel();

      print("URL => $url");
      print("BODY => ${request.toJson()}");

      final response = await patch(url, body: request.toJson());

      print("STATUS => ${response.statusCode}");
      print("RESPONSE => ${response.body}");

      if (response.statusCode == 200) {
        final data = UpdatePasswordWithoutLoginReqponseModel.fromJson(
          jsonDecode(response.body),
        );
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error updating password: $e");
      return null;
    }
  }

  //login
  Future<LoginResponseModel?> loginUser(LoginRequestModel login) async {
    final url = ApiEndpoints.login();
    final response = await post(
      url,
      body: login.toJson(),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = LoginResponseModel.fromJson(jsonDecode(response.body));

      await UserSession.save(data.token, data.user.toJson());
      return data;
    }
    return null;
  }

  Future<bool> registerUser(RegisterModel user) async {
    final url = ApiEndpoints.register();

    final response = await post(url, body: user.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Registration successful: ${response.body}');
      return true;
    } else {
      print('Registration failed: ${response.body}');
      return false;
    }
  }

  // Verify function
  Future<bool> verifyUser(VerifyModel verify) async {
    final url = ApiEndpoints.verify();
    final response = await post(url, body: verify.toJson());

    if (response.statusCode == 200) {
      print('Verification successful: ${response.body}');
      return true;
    } else {
      print('Verification failed: ${response.body}');
      return false;
    }
  }

  // Resend verification code
  Future<bool> resendVerificationCode(ResendVerifyModel resend) async {
    final url = ApiEndpoints.resendCode();
    final response = await post(url, body: resend.toJson());

    if (response.statusCode == 200) {
      print('Verification code resent: ${response.body}');
      return true;
    } else {
      print('Resend failed: ${response.body}');
      return false;
    }
  }

  /// Update user password
  Future<UpdatePasswordResponse?> updatePassword(
    UpdatePasswordRequest request,
  ) async {
    try {
      final url = ApiEndpoints.updatePassword(); // Add endpoint in ApiEndpoints

      final response = await post(url, body: request.toJson());

      if (response.statusCode == 200) {
        final data = UpdatePasswordResponse.fromJson(jsonDecode(response.body));
        return data;
      } else {
        print('Update password failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating password: $e');
      return null;
    }
  }
}

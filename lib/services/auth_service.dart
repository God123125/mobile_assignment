import 'dart:convert';

import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/auth/login_request_model.dart';
import 'package:khmer_cultur_app/models/auth/login_response_model.dart';
import 'package:khmer_cultur_app/models/auth/register_model.dart';
import 'package:khmer_cultur_app/models/auth/resend_verify_model.dart';
import 'package:khmer_cultur_app/models/auth/verify_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends BaseService {
  Future<bool> registerUser(RegisterModel user) async {
    final url = ApiEndpoints.register();

    final response = await post(
      url,
      body: user.toJson(),
    );

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
  //login
  Future<LoginResponseModel?> loginUser(LoginRequestModel login) async {
    final url = ApiEndpoints.login();
    final response = await post(url, body: login.toJson());

    if (response.statusCode == 200) {
      final data = LoginResponseModel.fromJson(jsonDecode(response.body));

      // Save token in session (optional)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data.token);
      await prefs.setString('user', jsonEncode(data.user.toJson()));

      return data;
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }
}

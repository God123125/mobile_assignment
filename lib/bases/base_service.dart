import 'dart:convert';

import 'package:khmer_cultur_app/bases/session_handler.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:http/http.dart' as http;

class BaseService {
  Future<Map<String, String>> get headers async {
    final token = await UserSession.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await headers,
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == 401) {
        SessionHelper.handleSessionExpired(); // token expired
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: await headers,
      );

      if (response.statusCode == 401) {
        SessionHelper.handleSessionExpired(); // token expired
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}

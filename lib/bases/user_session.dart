import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmer_cultur_app/models/auth/user_model.dart';

class UserSession {
  static UserModel? _currentUser;
  static final _storage = FlutterSecureStorage();

  /// Save token and user profile securely
  static Future<void> save(String token, Map<String, dynamic> user) async {
  _currentUser = UserModel.fromJson(user);
  await _storage.write(key: "token", value: token);
  await _storage.write(key: "user", value: jsonEncode(user));
  //Save User Profile and Tocket to Memory
}
  /// Get stored token
  static Future<String?> getToken() async {
  return await _storage.read(key: "token");
  //Return Token Data from memory
}
  static Future<UserModel?> getCurrentUser() async {
  if (_currentUser != null) return _currentUser;
  final userStr = await _storage.read(key: "user");
  if (userStr == null) return null;
  _currentUser = UserModel.fromJson(jsonDecode(userStr));
  return _currentUser;
  //Read user profile from memory and convert to object
}
/// Get fields directly from cached user
  static String? getEmail() => _currentUser?.email;
  static String? getName() => _currentUser?.name;
  /// Clear all
  static Future<void> clear() async {
    _currentUser = null;
    await _storage.deleteAll();
  }

  /// Check login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

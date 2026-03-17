import 'package:shared_preferences/shared_preferences.dart';

class AddressStorageService {
  static const String selectedAddressKey = "selected_address";

  /// Save selected address
  static Future<void> saveSelectedAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedAddressKey, address);
  }

  /// Get saved address
  static Future<String?> getSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedAddressKey);
  }
}
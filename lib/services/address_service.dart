import 'package:shared_preferences/shared_preferences.dart';

class AddressStorageService {
  static const String selectedAddressKey = "selected_address";
  static const String selectedLatKey = "selected_lat";
  static const String selectedLonKey = "selected_lon";

  static Future<void> saveSelectedAddress({
    required String address,
    required double lat,
    required double lon,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedAddressKey, address);
    await prefs.setDouble(selectedLatKey, lat);
    await prefs.setDouble(selectedLonKey, lon);
  }

  static Future<String?> getSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedAddressKey);
  }

  static Future<double?> getSelectedLat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(selectedLatKey);
  }

  static Future<double?> getSelectedLon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(selectedLonKey);
  }
}
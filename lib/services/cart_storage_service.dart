// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class CartStorage {
//   static const String _prefix = 'cart_store_';

//   static String _key(String storeId) => '$_prefix$storeId';

//   /// Save quantities map for a specific store
//   static Future<void> saveCart(String storeId, Map<String, int> quantities) async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = jsonEncode(quantities);
//     await prefs.setString(_key(storeId), jsonString);
//   }

//   /// Load quantities for a specific store
//   static Future<Map<String, int>> loadCart(String storeId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString(_key(storeId));
//     if (jsonString == null || jsonString.isEmpty) {
//       return {};
//     }
//     try {
//       final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
//       return decoded.map((key, value) => MapEntry(key, value as int));
//     } catch (e) {
//       return {};
//     }
//   }

//   /// Clear cart for a specific store
//   static Future<void> clearCart(String storeId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_key(storeId));
//   }

//   /// Optional: clear ALL carts (useful for logout / app reset)
//   static Future<void> clearAllCarts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final keys = prefs.getKeys();
//     for (final key in keys) {
//       if (key.startsWith(_prefix)) {
//         await prefs.remove(key);
//       }
//     }
//   }
// }
// services/cart_storage_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartStorageService extends ChangeNotifier {
  static final CartStorageService _instance = CartStorageService._internal();
  factory CartStorageService() => _instance;
  CartStorageService._internal();

  static const String _prefix = 'cart_store_';
  
  // Cache to avoid repeated SharedPreferences reads
  final Map<String, Map<String, int>> _cartCache = {};
  
  String _key(String storeId) => '$_prefix$storeId';

  /// Save quantities map for a specific store
  Future<void> saveCart(String storeId, Map<String, int> quantities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(quantities);
    await prefs.setString(_key(storeId), jsonString);
    
    // Update cache
    _cartCache[storeId] = Map.from(quantities);
    
    // Notify all listeners
    notifyListeners();
  }

  /// Load quantities for a specific store
  Future<Map<String, int>> loadCart(String storeId) async {
    // Return from cache if available
    if (_cartCache.containsKey(storeId)) {
      return Map.from(_cartCache[storeId]!);
    }
    
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key(storeId));
    
    Map<String, int> cart;
    if (jsonString == null || jsonString.isEmpty) {
      cart = {};
    } else {
      try {
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        cart = decoded.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        cart = {};
      }
    }
    
    // Update cache
    _cartCache[storeId] = Map.from(cart);
    return cart;
  }

  /// Get current quantity for a specific product in a store
  int getQuantity(String storeId, String productId) {
    return _cartCache[storeId]?[productId] ?? 0;
  }

  /// Update quantity for a specific product
  Future<void> updateQuantity(String storeId, String productId, int newQuantity) async {
    // Ensure store exists in cache
    if (!_cartCache.containsKey(storeId)) {
      await loadCart(storeId);
    }
    
    if (newQuantity <= 0) {
      _cartCache[storeId]?.remove(productId);
    } else {
      _cartCache[storeId] ??= {};
      _cartCache[storeId]![productId] = newQuantity;
    }
    
    // Save to persistent storage
    await saveCart(storeId, _cartCache[storeId] ?? {});
  }

  /// Clear cart for a specific store
  Future<void> clearCart(String storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(storeId));
    _cartCache.remove(storeId);
    notifyListeners();
  }

  /// Get total items in cart for a store
  int getTotalItems(String storeId) {
    final cart = _cartCache[storeId];
    if (cart == null) return 0;
    return cart.values.fold(0, (a, b) => a + b);
  }

  /// Get all quantities for a store
  Map<String, int> getCartForStore(String storeId) {
    return Map.from(_cartCache[storeId] ?? {});
  }

  /// Optional: clear ALL carts (useful for logout / app reset)
  static Future<void> clearAllCarts() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_prefix)) {
        await prefs.remove(key);
      }
    }
    _instance._cartCache.clear();
    _instance.notifyListeners();
  }
}
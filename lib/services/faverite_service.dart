import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoritesKey = "favorites";

  /// Get list of favorite product IDs
  Future<List<String>> _getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  /// Check if a product is favorite
  Future<bool> isFavorite(String productId) async {
    final favorites = await _getFavorites();
    return favorites.contains(productId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String productId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await _getFavorites();

    if (isFavorite) {
      if (!favorites.contains(productId)) {
        favorites.add(productId);
      }
    } else {
      favorites.remove(productId);
    }

    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Get all favorite products
  Future<List<String>> getFavorites() async {
    return await _getFavorites();
  }
}
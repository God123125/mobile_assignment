import 'dart:math';

import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/store_model.dart';

class LocationUtils {
  /// Compute distance in km
  static String getDistanceKm({
    required Store store,
    double? userLat,
    double? userLon,
  }) {
    userLat ??= UserSession.getLatitude();
    userLon ??= UserSession.getLongitude();

    if (userLat == null || userLon == null) return "Unknown";

    final distanceMeters = _calculateDistance(
      userLat,
      userLon,
      store.address.latitude,
      store.address.longitude,
    );

    final distanceKm = distanceMeters / 1000;
    return "${distanceKm.toStringAsFixed(1)} km";
  }

  static String getDeliveryFee({
    required Store store,
    double? userLat,
    double? userLon,
  }) {
    userLat ??= UserSession.getLatitude();
    userLon ??= UserSession.getLongitude();

    if (userLat == null || userLon == null) return "Not available";

    final distanceMeters = _calculateDistance(
      userLat,
      userLon,
      store.address.latitude,
      store.address.longitude,
    );

    final distanceKm = distanceMeters / 1000;

    if (distanceKm > 5) {
      return "Not available"; // Beyond 5km
    }

    double fee;
    if (distanceKm < 1) {
      fee = 0.5;
    } else if (distanceKm < 2) {
      fee = 0.75;
    } else {
      fee = 1.5; // <5km
    }

    return "\$${fee.toStringAsFixed(2)}";
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000; // Earth radius in meters
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _degToRad(double deg) => deg * pi / 180;

  /// Estimate delivery time in minutes
  static String getEstimatedTime({
    required Store store,
    double? userLat,
    double? userLon,
    double avgSpeedKmPerHour = 8, //8km/h
  }) {
    userLat ??= UserSession.getLatitude();
    userLon ??= UserSession.getLongitude();

    if (userLat == null || userLon == null) return "Unknown";

    final distanceMeters = _calculateDistance(
      userLat,
      userLon,
      store.address.latitude,
      store.address.longitude,
    );

    final distanceKm = distanceMeters / 1000;
    final timeHours = distanceKm / avgSpeedKmPerHour;
    final timeMinutes = (timeHours * 60).ceil();

    return "$timeMinutes min";
  }
}

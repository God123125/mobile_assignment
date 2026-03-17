import 'dart:convert';

import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/auth/confirm_order_request.dart';
import 'package:khmer_cultur_app/models/auth/order_model.dart';
import '../bases/api_endpoints.dart';

class OrderService extends BaseService {
  Future<bool> cancelOrder(String orderId, CancelOrderRequest request) async {
    final response = await post(
      ApiEndpoints.confirmOrder(orderId),
      body: request.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> checkout(OrderRequest order) async {
    final response = await post(ApiEndpoints.addOrder(), body: order.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await get(ApiEndpoints.getOrder);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('list')) {
        final data = jsonResponse['list'] as List;
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((e) => OrderModel.fromJson(e)).toList();
      }
    }

    return [];
  }

  /// Get completed orders only
  Future<List<OrderModel>> getCompletedOrders() async {
    final orders = await getOrders();
    return orders.where((o) => o.status.toLowerCase() == 'completed').toList();
  }

  /// Get ongoing/pending orders only
  Future<List<OrderModel>> getOngoingOrders() async {
    final orders = await getOrders();
    return orders.where((o) => o.status.toLowerCase() != 'completed').toList();
  }
}

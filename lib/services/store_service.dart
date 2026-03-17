import 'dart:convert';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/store_model.dart';

class StoreService extends BaseService {

  Future<List<Store>> fetchStores() async {

    final response = await get(ApiEndpoints.getStores);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'];

      return list.map((e) => Store.fromJson(e)).toList();

    } else {
      throw Exception('Failed to load stores');
    }
  }
}
import 'dart:convert';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/store_model.dart';

class StoreCategoryService extends BaseService {
  Future<List<StoreCategory>> fetchCategories() async {
    final response = await get(ApiEndpoints.getStoreCategories);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'];

      return list.map((e) => StoreCategory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
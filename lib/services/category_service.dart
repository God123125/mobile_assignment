import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/models/category_model.dart';

class CategoryModelService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.getCagories));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> list = data['list'] ?? [];

        return list.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}

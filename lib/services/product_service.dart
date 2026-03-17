import 'dart:convert';

import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/product_model.dart';
import 'package:khmer_cultur_app/models/store_model.dart';

class ProductService extends BaseService {

  Future<List<Product>> fetchProducts() async {
    final response = await get(ApiEndpoints.getProducts);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> list = data['list'] ?? [];

      return list.map((json) => Product.fromJson(json)).toList();
    } 
    else if (response.statusCode == 401) {
      throw Exception('Unauthorized - session expired');
    } 
    else {
      throw Exception(
        'Failed to load products: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Product>> fetchProductsWithStore() async {
  // Fetch products and stores
  final productsResponse = await get(ApiEndpoints.getProducts);
  final storesResponse = await get(ApiEndpoints.getStores);

  if (productsResponse.statusCode == 200 && storesResponse.statusCode == 200) {
    final productData = jsonDecode(productsResponse.body)['list'] as List;
    final storeData = jsonDecode(storesResponse.body)['list'] as List;

    // Convert stores to a map for fast lookup
    final storeMap = {for (var s in storeData) s['_id']: Store.fromJson(s)};

    // Map products and attach store info
    final products = productData.map((p) {
      final product = Product.fromJson(p);
      if (storeMap.containsKey(product.store)) {
        product.storeInfo = storeMap[product.store];
      }
      return product;
    }).toList();

    return products;
  } else {
    throw Exception('Failed to load products or stores');
  }
}
}
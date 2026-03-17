import 'dart:convert';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/ad_image_model.dart';

class AdvertisingService extends BaseService {

  Future<List<Advertising>> fetchAdvertisings() async {

    final response = await get(ApiEndpoints.getAdvertisings);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final List list = data['list'];

      return list.map((e) => Advertising.fromJson(e)).toList();

    } else {
      throw Exception('Failed to load advertisings');
    }
  }
}
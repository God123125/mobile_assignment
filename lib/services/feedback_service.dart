import 'dart:convert';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/base_service.dart';
import 'package:khmer_cultur_app/models/auth/feedback_model.dart';

class FeedbackService extends BaseService {

  Future<List<FeedbackModel>> fetchFeedbacks(String storeId) async {

    final response = await get(
      "${ApiEndpoints.getFeedback}?store=$storeId",
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      final List list = data['list'];

      return list.map((e) => FeedbackModel.fromJson(e)).toList();

    } else {
      throw Exception('Failed to load feedbacks');
    }
  }
}
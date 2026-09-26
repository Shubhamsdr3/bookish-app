import 'package:network_service/api_endpoints.dart';
import 'package:network_service/old_api_service.dart';
import 'package:dio/dio.dart';

abstract class IFeedbackRepository {
  Future<Response> submitFeedback(Map<String, dynamic> payload);
}

class FeedbackRepository extends IFeedbackRepository {
  @override
  Future<Response> submitFeedback(Map<String, dynamic> payload) {
    return OldApiService.instance.request(
        endpoint: ApiEndPoint.SUBMIT_FEEDBACK_URL,
        method: DioMethod.post,
        param: payload);
  }
}

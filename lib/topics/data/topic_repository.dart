import 'package:bookish_module/core/base_repository.dart';
import 'package:bookish_module/topics/data/topic_api_service.dart';
import 'package:bookish_module/topics/domain/model/book_topic_response.dart';
import 'package:network_service/api.dart';
import 'package:network_service/network_manager.dart';
import 'package:network_service/util/user_store.dart';

abstract class ITopicRepository extends IRepository {
  ITopicRepository({required super.services});

  Future<ApiResponse<BookTopicResponse>> fetchTopics();

  Future<void> subscribeTopic(Map<String, dynamic> payload);
}

class TopicRepository extends ITopicRepository {
  TopicRepository({required super.services});

  late final TopicApiService _apiService = getService<TopicApiService>();

  @override
  Future<ApiResponse<BookTopicResponse>> fetchTopics() async {
    try {
      final response = await NetworkManager().makeNetworkCall(
          api: _apiService.bookTopics,
          converter: (json) => BookTopicResponse.fromMap(json),
          resultKey: 'data');
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  @override
  Future<void> subscribeTopic(Map<String, dynamic> payload) async {
    try {
      final userId = await UserStore.getUserId();
      await NetworkManager()
          .makeNetworkCall(api: _apiService.subscribeTopics(userId), resultKey: 'data');
    } catch (ex) {
      rethrow;
    }
  }
}

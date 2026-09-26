import 'package:network_service/api.dart';

class TopicApiService {

  IApi get bookTopics {
    return Api(name: '/api/bookish/book/topics', method: ApiMethod.get);
  }

  IApi subscribeTopics(String userId) {
    return Api(name: '/api/bookish/book/topics/subscribe/${userId}', method: ApiMethod.post);
  }
}

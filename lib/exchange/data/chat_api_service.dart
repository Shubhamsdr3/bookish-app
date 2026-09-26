import 'package:network_service/api.dart';

class ChatApiService {
  IApi chatUsers(String userId) {
    return Api(
        name: '/api/bookish/exchange/friends?userId=$userId',
        method: ApiMethod.get);
  }
}

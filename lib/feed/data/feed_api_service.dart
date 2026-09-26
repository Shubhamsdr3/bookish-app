import 'package:network_service/api.dart';
import 'package:network_service/api_endpoints.dart';

class FeedApiService {
  IApi get feedData {
    return Api(name: ApiEndPoint.HOME_FEED_URL, method: ApiMethod.get);
  }

  IApi get bookDetail {
    return Api(name: ApiEndPoint.GET_BOOK_DETAIL_URL, method: ApiMethod.get);
  }

  IApi get deletePost {
    return Api(
        name: ApiEndPoint.HOME_FEED_DELETE_POST, method: ApiMethod.delete);
  }
}

import 'package:network_service/api.dart';
import 'package:network_service/api_endpoints.dart';

class AuthApiService {
  IApi get authenticate {
    return Api(name: ApiEndPoint.LOGIN_URL, method: ApiMethod.post);
  }
}

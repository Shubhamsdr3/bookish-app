import 'package:network_service/api.dart';
import 'package:network_service/api_endpoints.dart';

class AuthApiService {
  IApi authenticate({String? bearerToken}) {
    final bool hasBearer = bearerToken != null && bearerToken.isNotEmpty;
    return Api(
      name: ApiEndPoint.LOGIN_URL,
      method: ApiMethod.post,
      headers: hasBearer ? {'Authorization': 'Bearer $bearerToken'} : null,
    );
  }

  IApi updateProfile({String? bearerToken}) {
    final bool hasBearer = bearerToken != null && bearerToken.isNotEmpty;
    return Api(
      name: ApiEndPoint.PROFILE_INFO_URL,
      method: ApiMethod.put,
      headers: hasBearer ? {'Authorization': 'Bearer $bearerToken'} : null,
    );
  }
}

import 'package:bookish/core/base_repository.dart';
import 'package:network_service/data/reader.dart';
import 'package:network_service/api.dart';
import 'package:network_service/exceptions/http_api_exception.dart';
import 'package:network_service/network_manager.dart';
import 'package:bookish/onboarding/data/auth_api_service.dart';
import 'package:bookish/onboarding/data/login_request.dart';
import 'package:network_service/util/user_store.dart';

abstract class IOnboardingRepository extends IRepository {
  IOnboardingRepository({required super.services});

  Future<ApiResponse<UserData>> loginUser(LoginRequest request);

  Future<ApiResponse<dynamic>> updateProfile(LoginRequest request);
}

class OnboardingRepository extends IOnboardingRepository {
  OnboardingRepository({required super.services});

  late final AuthApiService _authApiService = getService<AuthApiService>();

  @override
  Future<ApiResponse<UserData>> loginUser(LoginRequest request) async {
    try {
      final String? firebaseIdToken = request.firebaseIdToken;
      final String? bearerToken = firebaseIdToken != null &&
              firebaseIdToken.isNotEmpty
          ? firebaseIdToken
          : null;
      return await NetworkManager().makeNetworkCall(
        api: _authApiService.authenticate(bearerToken: bearerToken),
        converter: (json) => UserData.fromJson(json),
        body: request.toJson(),
        resultKey: 'data',
        onApiError: (e, [s]) {
          if (e is HttpApiException) {
            return e.message ?? 'An error occurred';
          }
          return 'An unexpected error occurred';
        },
      );
    } catch (ex) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> updateProfile(LoginRequest request) async {
    try {
      final authToken = await UserStore.getAuthToken();
      return await NetworkManager().makeNetworkCall(
        api: _authApiService.updateProfile(bearerToken: authToken),
        body: request.toJson(),
        resultKey: 'data',
        onApiError: (e, [s]) {
          if (e is HttpApiException) {
            return e.message ?? 'An error occurred';
          }
          return 'An unexpected error occurred';
        },
      );
    } catch (ex) {
      rethrow;
    }
  }
}

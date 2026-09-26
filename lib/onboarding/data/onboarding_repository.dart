import 'package:bookish_module/core/base_repository.dart';
import 'package:network_service/data/reader.dart';
import 'package:network_service/api.dart';
import 'package:network_service/network_manager.dart';
import 'package:bookish_module/onboarding/data/auth_api_service.dart';

abstract class IOnboardingRepository extends IRepository {
  IOnboardingRepository({required super.services});

  Future<ApiResponse<UserData>> loginUser(Map<String, dynamic> payload);
}

class OnboardingRepository extends IOnboardingRepository {
  OnboardingRepository({required super.services});

  late final AuthApiService _authApiService = getService<AuthApiService>();

  @override
  Future<ApiResponse<UserData>> loginUser(Map<String, dynamic> payload) async {
    try {
      return await NetworkManager().makeNetworkCall(
        api: _authApiService.authenticate,
        converter: (json) => UserData.fromJson(json),
        body: payload,
        resultKey: 'data'
      );
    } catch (ex) {
      rethrow;
    }
  }
}

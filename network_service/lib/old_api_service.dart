import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network_service/util/constants.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'curl_logging_dio_interceptor.dart';
import 'exceptions/unauthorized_exception.dart';

enum DioMethod { post, get, put, delete }

@Deprecated("Use new one #ApiService")
class OldApiService {
  OldApiService._singleton();

  static final OldApiService instance = OldApiService._singleton();

  /// Create the adapter first, then register it with Alice via .addAdapter()
  static final AliceDioAdapter _aliceDioAdapter = AliceDioAdapter();

  static final Alice _alice = Alice(
      configuration: AliceConfiguration(
          showNotification: true, showInspectorOnShake: true))
    ..addAdapter(_aliceDioAdapter);

  Future<Response> makeRequest(
      {required String endpoint,
      DioMethod method = DioMethod.post,
      Map<String, dynamic>? param,
      dynamic formData,
      String? contentType,
      String? authToken}) async {
    try {
      return await request(
          endpoint: endpoint,
          method: method,
          param: param,
          formData: formData,
          contentType: contentType,
          authToken: authToken);
    } on DioException catch (e) {
      final response = e.response;
      if (response?.statusCode == 401) {
        throw UnAuthorizedException("User logged out");
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> request(
      {required String endpoint,
      DioMethod method = DioMethod.post,
      Map<String, dynamic>? param,
      dynamic formData,
      String? contentType,
      String? authToken}) async {
    try {
      final dio = Dio(
        BaseOptions(
          followRedirects: false,
          baseUrl: Constants.BASE_URL,
          contentType: contentType ?? Headers.jsonContentType,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            if (authToken != null && authToken.isNotEmpty)
              "Authorization": "Bearer $authToken"
          },
        ),
      );

      if (kDebugMode) {
        dio.interceptors.add(_aliceDioAdapter);
        dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      }

      debugPrint("Making api call:  ${Constants.BASE_URL}$endpoint");
      switch (method) {
        case DioMethod.post:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.get:
          return dio.get(
            endpoint,
            queryParameters: param,
          );
        case DioMethod.put:
          return dio.put(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.delete:
          return dio.delete(
            endpoint,
            data: param ?? formData,
          );
        default:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
      }
    } catch (e) {
      rethrow;
    }
  }
}

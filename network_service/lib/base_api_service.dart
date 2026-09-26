import 'dart:async';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network_service/util/constants.dart';

import 'curl_logging_dio_interceptor.dart';
import 'interceptors/auth_interceptor.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late final Dio apiClient;
  late final Alice alice;

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  /// Optional callback when a 401 is detected (e.g., navigate to login)
  VoidCallback? onSessionExpired;

  Future<void> initialize({VoidCallback? onSessionExpired}) async {
    this.onSessionExpired = onSessionExpired;

    final aliceAdapter = AliceDioAdapter();
    alice = Alice(
      configuration: AliceConfiguration(
        showNotification: true,
        showInspectorOnShake: true,
      ),
    )..addAdapter(aliceAdapter);

    apiClient = Dio(
      BaseOptions(
        followRedirects: false,
        baseUrl: Constants.BASE_URL,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );


    apiClient.interceptors.add(
      AuthInterceptor(onSessionExpired: onSessionExpired),
    );

    if (kDebugMode) {
      apiClient.interceptors.addAll([
        aliceAdapter,
        CurlLoggerDioInterceptor(printOnSuccess: true),
      ]);
    }
  }

  void setHeaders(Map<String, String> headers) {
    apiClient.options.headers.addAll(headers);
  }

  void removeHeaders(List<String> headers) {
    for (final header in headers) {
      apiClient.options.headers.remove(header);
    }
  }
}

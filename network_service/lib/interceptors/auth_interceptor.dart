import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../util/user_store.dart';

/// Interceptor that dynamically attaches the auth token to every request.
///
/// This is the recommended approach because:
/// 1. Token is fetched fresh for every request (handles token refresh/login/logout)
/// 2. Handles 401 responses centrally (session expiry)
/// 3. Single place to manage auth logic
class AuthInterceptor extends Interceptor {
  final VoidCallback? onSessionExpired;

  AuthInterceptor({this.onSessionExpired});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip if the request already has an Authorization header (e.g., refresh token calls)
    if (options.headers.containsKey('Authorization')) {
      return handler.next(options);
    }

    final token = await UserStore.getAuthToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      debugPrint('AuthInterceptor: 401 Unauthorized - Session expired');
      onSessionExpired?.call();
    }
    return handler.next(err);
  }
}


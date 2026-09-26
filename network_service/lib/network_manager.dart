import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_service/base_api_service.dart';

import 'api.dart';
import 'exceptions/http_api_exception.dart';

typedef ApiError = String Function(Object e, [StackTrace? s]);

class NetworkManager {
  static final _instance = NetworkManager._();

  NetworkManager._();

  factory NetworkManager() => _instance;

  Future<ApiResponse<T>> makeNetworkCall<T>(
      {required IApi api,
      ResponseConverter<T>? converter,
      dynamic body,
      CancelToken? cancelToken,
      String? resultKey,
      ApiError? onApiError}) async {
    final ApiResponse<T> resource = ApiResponse<T>();

    Response<dynamic> response;

    try {
      response = await _futureResponseOf<dynamic>(api, body, cancelToken);

      final isSuccess = response.data['isSuccess'] == true;

      if (response.statusCode == 200 && isSuccess) {
        final resData = resultKey?.isNotEmpty == true
            ? response.data[resultKey]
            : response.data;

        resource.set(
            status: ApiStatus.success,
            data: converter?.call(resData) ?? resData);
      } else {
        throw HttpApiException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.statusMessage,
        );
      }
    } catch (e, s) {
      debugPrint("APP API ERROR :: $e  $s");
      resource.set(
          status: ApiStatus.error,
          message: e is DioException
              ? onApiError!(
                  HttpApiException(
                      requestOptions: e.requestOptions,
                      message: e.message,
                      response: e.response,
                      stackTrace: e.stackTrace,
                      error: e.error),
                  s)
              : onApiError!(e, s));
    }

    return resource.status == ApiStatus.success
        ? Future.value(resource)
        : Future.error(resource.message);
  }

  Future<Response<T>> _futureResponseOf<T>(IApi api,
      [dynamic requestData, CancelToken? cancelToken]) {
    Completer<Response<T>> responseCompleter = Completer();

    final options = api.headers != null ? Options(headers: api.headers) : null;

    final apiClient = ApiService().apiClient;

    switch (api.method) {
      case ApiMethod.post:
        responseCompleter.complete(apiClient.post<T>(api.name,
            data: requestData, cancelToken: cancelToken, options: options));
        break;

      case ApiMethod.delete:
        responseCompleter.complete(apiClient.delete<T>(api.name,
            queryParameters: requestData,
            cancelToken: cancelToken,
            options: options));
        break;

      case ApiMethod.put:
        responseCompleter.complete(apiClient.put<T>(api.name,
            data: requestData, cancelToken: cancelToken, options: options));
        break;

      case ApiMethod.request:
        responseCompleter.complete(apiClient.request<T>(api.name,
            data: requestData,
            cancelToken: cancelToken,
            options: Options(method: 'GET', headers: api.headers)));
        break;

      default:
        responseCompleter.complete(apiClient.get<T>(api.name,
            queryParameters: requestData,
            cancelToken: cancelToken,
            options: options));
        break;
    }

    return responseCompleter.future;
  }

  void _handleErrorResponse<T>(e, ApiResponse resource) {
    if (e is DioException) {
      String errorMessage = _getErrorMessage(e);
      if (e.response?.statusCode == 401) {
        resource.set(status: ApiStatus.sessionExpired, message: errorMessage);
      } else {
        if (e.message?.contains("SocketException") ?? false) {
          resource.set(status: ApiStatus.noInternet, message: errorMessage);
        } else {
          resource.set(status: ApiStatus.error, message: errorMessage);
        }
      }
    } else {
      resource.set(status: ApiStatus.error, message: e.toString());
    }
  }

  Widget handleSnapshot<T>(
      AsyncSnapshot<ApiResponse<T>> snapshot, Widget Function(T) builder,
      {Widget loading = const Center(
        child: CircularProgressIndicator(),
      ),
      Widget error = const SizedBox(),
      void Function(ApiStatus, String)? onError}) {
    if (snapshot.hasData) {
      switch (snapshot.data!.status) {
        case ApiStatus.success:
          return snapshot.data?.data == null
              ? loading
              : builder(snapshot.data!.data as T);

        case ApiStatus.loading:
          return loading;

        default:
          onError?.call(snapshot.data!.status, snapshot.data!.message);
          return snapshot.data!.data == null
              ? error
              : builder(snapshot.data!.data as T);
      }
    } else {
      return loading;
    }
  }

  String _getErrorMessage(DioException e) {
    debugPrint(e.toString());
    return e.toString();
    // if (e.response?.data is Map) {
    //   return e.response!.data['message'] ?? e.response!.data['error'];
    // }
    // return e.message ?? "Something went wrong.";
  }
}

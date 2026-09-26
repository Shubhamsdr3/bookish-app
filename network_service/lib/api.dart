import 'dart:core';

import 'base_api_service.dart';

typedef ResponseConverter<T> = T Function(dynamic);

enum ApiMethod { get, post, put, delete, patch, request }

enum ApiStatus {
  success,
  error,
  sessionExpired,
  loading,
  noInternet,
  empty,
  timeout,
}

class ApiResponse<T> {
  T? _data;
  ApiStatus _status = ApiStatus.loading;
  String _message = "";

  T? get data => _data;

  ApiResponse({T? data, ApiStatus? status, String? message}) {
    this._data = data;
    this._status = status ?? ApiStatus.loading;
    this._message = message ?? "";
  }

  ApiStatus get status => _status;

  String get message => _message;

  ApiResponse<T> copyWith({ApiStatus? status, T? data, String? message}) {
    if (data != null) {
      this._data = data;
    }
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    return ApiResponse<T>(
        status: status ?? _status,
        data: data ?? _data,
        message: message ?? _message);
  }

  void set({required ApiStatus status, T? data, String message = ""}) {
    _data = data;
    _status = status;
    _message = message;
  }

  @override
  String toString() {
    return message;
  }

  bool get isSuccess => status == ApiStatus.success;
}

abstract class IApi {
  String get name;

  Uri get uri;

  ApiMethod? get method;

  String? get version;

  Map<String, dynamic>? get headers;
}

class Api implements IApi {
  late String _name;
  @override
  final ApiMethod? method;
  @override
  final Map<String, dynamic>? headers;
  @override
  final String? version;
  final String? suffix;

  Api(
      {required String name,
      required this.method,
      this.headers,
      this.version = '',
      this.suffix = ''}) {
    _name = name;
  }

  void setPath(Map<String, String> paths) {
    paths.forEach((key, value) {
      _name = _name.replaceFirst("{$key}", value);
    });
  }

  @override
  String get name => "$suffix$version$_name";

  @override
  Uri get uri => Uri.parse("${ApiService().apiClient.options.baseUrl}$name");
}

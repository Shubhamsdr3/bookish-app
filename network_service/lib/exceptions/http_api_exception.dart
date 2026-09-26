import 'package:dio/dio.dart';

class HttpApiException extends DioException {
  HttpApiException({
    required super.requestOptions,
    super.error,
    super.message,
    super.response,
    super.stackTrace,
  });

  String get errorType => super.type.name;
}

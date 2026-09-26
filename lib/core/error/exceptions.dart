class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({required super.message});
}

class NetworkException extends AppException {
  NetworkException({required super.message});
}

class CacheException extends AppException {
  CacheException({required super.message});
}

class ValidationException extends AppException {
  ValidationException({required super.message});
}

class UnknownException extends AppException {
  UnknownException({required super.message});
}


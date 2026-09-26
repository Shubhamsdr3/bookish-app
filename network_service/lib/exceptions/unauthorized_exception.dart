class UnAuthorizedException implements Exception {

  final String? errorMessage;
  UnAuthorizedException(this.errorMessage);
}
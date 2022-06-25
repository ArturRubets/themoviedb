enum ApiClientExceptionType {
  auth,
  network,
  sessionExpired,
  other,
}

class ApiClientException implements Exception {
  const ApiClientException({
    required this.type,
    this.message,
  });

  final ApiClientExceptionType type;
  final String? message;
}

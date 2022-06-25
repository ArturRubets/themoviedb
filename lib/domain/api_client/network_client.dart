import '../../configuration/configuration.dart';
import 'api_client_exception.dart';

class NetworkClient {
  Uri makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('${Configuration.host}$path');
    if (parameters != null) return uri.replace(queryParameters: parameters);

    return uri;
  }

  void validateResponse(int statusCode, Map<String, dynamic> jsonBody) {
    if (statusCode == 401) {
      final dynamic status = jsonBody['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw const ApiClientException(type: ApiClientExceptionType.auth);
      }
      if (code == 3) {
        throw const ApiClientException(
            type: ApiClientExceptionType.sessionExpired);
      }
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
  }
}

import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../configuration/configuration.dart';
import 'api_client_exception.dart';
import 'network_client.dart';

class AuthApiClient {
  final _networkClient = NetworkClient();

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    try {
      final token = await _makeToken();

      final validToken = await _validateUser(
        username: username,
        password: password,
        requestToken: token,
      );
      final sessionId = _makeSession(requestToken: validToken);
      return sessionId;
    } on ApiClientException {
      rethrow;
    } on SocketException catch (e) {
      throw ApiClientException(
        type: ApiClientExceptionType.network,
        message: e.message,
      );
    } catch (e) {
      throw ApiClientException(
        type: ApiClientExceptionType.other,
        message: e.toString(),
      );
    }
  }

  Future<String> _makeToken() async {
    final url = _networkClient.makeUri(
      '/authentication/token/new',
      <String, dynamic>{'api_key': Configuration.apiKey},
    );

    final response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final requestToken = jsonResponse['request_token'] as String;

    return requestToken;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final url = _networkClient.makeUri(
        '/authentication/token/validate_with_login',
        <String, dynamic>{'api_key': Configuration.apiKey});

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    var response = await http.post(url, body: parameters);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final requestTokenResponse = jsonResponse['request_token'] as String;

    return requestTokenResponse;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final url = _networkClient.makeUri('/authentication/session/new',
        <String, dynamic>{'api_key': Configuration.apiKey});

    final parameters = convert.jsonEncode(<String, String>{
      'request_token': requestToken,
    });

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString()
    };

    var response = await http.post(
      url,
      headers: headers,
      body: parameters,
    );

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final sessionId = jsonResponse['session_id'] as String;

    return sessionId;
  }
}

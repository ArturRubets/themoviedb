import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../configuration/configuration.dart';
import 'network_client.dart';

enum MediaType {
  movie,
  tv,
}

class AccountApiClient {
  final _networkClient = NetworkClient();

  Future<int?> getAccountId(String sessionId) async {
    final url = _networkClient.makeUri(
      '/account',
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final result = jsonResponse['id'] as int?;

    return result;
  }

  Future<void> markAsFavotite({
    required int accountId,
    required String sessionId,
    MediaType mediaType = MediaType.movie,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final url = _networkClient.makeUri(
      '/account/$accountId/favorite',
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );

    final parameters = convert.json.encode(<String, dynamic>{
      'media_type': mediaType.name,
      'media_id': mediaId,
      'favorite': isFavorite,
    });

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString()
    };

    final response = await http.post(
      url,
      headers: headers,
      body: parameters,
    );

    final jsonBody = convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonBody);
  }
}

import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../entity/movie_details.dart';
import '../entity/popular_movie_response.dart';

enum ApiClientExceptionType {
  auth,
  network,
  sessionExpired,
  other,
}

enum MediaType {
  movie,
  tv,
}

class ApiClientException implements Exception {
  const ApiClientException({
    required this.type,
    this.message,
  });

  final ApiClientExceptionType type;
  final String? message;
}

class ApiClient {
  static const _host = 'https://api.themoviedb.org/3';
  static const _apiKey = '03bf18a1588eb1f64c6692e2ed80e646';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const username = '';
  static const password = '';

  static String imageUrl(String path) => _imageUrl + path;

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

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) return uri.replace(queryParameters: parameters);

    return uri;
  }

  Future<String> _makeToken() async {
    final url = _makeUri(
      '/authentication/token/new',
      <String, dynamic>{'api_key': _apiKey},
    );

    final response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final requestToken = jsonResponse['request_token'] as String;

    return requestToken;
  }

  Future<int?> getAccountId(String sessionId) async {
    final url = _makeUri(
      '/account',
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final result = jsonResponse['id'] as int?;

    return result;
  }

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    var url = _makeUri(
      '/movie/popular',
      <String, dynamic>{
        'api_key': _apiKey,
        'language': locale,
        'page': page.toString(),
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);

    return popularMovieResponse;
  }

  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query) async {
    var url = _makeUri(
      '/search/movie',
      <String, dynamic>{
        'api_key': _apiKey,
        'language': locale,
        'page': page.toString(),
        'query': query,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);

    return popularMovieResponse;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    var url = _makeUri(
      '/movie/$movieId',
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': _apiKey,
        'language': locale,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final movieDetails = MovieDetails.fromJson(jsonResponse);

    return movieDetails;
  }

  Future<bool?> isFavorite(int movieId, String sessionId) async {
    var url = _makeUri(
      '/movie/$movieId/account_states',
      <String, dynamic>{
        'session_id': sessionId,
        'api_key': _apiKey,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final result = jsonResponse['favorite'] as bool?;

    return result;
  }

  Future<bool> markAsFavotite({
    required int accountId,
    required String sessionId,
    MediaType mediaType = MediaType.movie,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final url = _makeUri(
      '/account/$accountId/favorite',
      <String, dynamic>{
        'api_key': _apiKey,
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

    _validateResponse(response.statusCode, jsonBody);

    return true;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final url = _makeUri('/authentication/token/validate_with_login',
        <String, dynamic>{'api_key': _apiKey});

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    var response = await http.post(url, body: parameters);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _validateResponse(response.statusCode, jsonResponse);

    final requestTokenResponse = jsonResponse['request_token'] as String;

    return requestTokenResponse;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final url = _makeUri(
        '/authentication/session/new', <String, dynamic>{'api_key': _apiKey});

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

    _validateResponse(response.statusCode, jsonResponse);

    final sessionId = jsonResponse['session_id'] as String;

    return sessionId;
  }

  void _validateResponse(int statusCode, Map<String, dynamic> jsonBody) {
    if (statusCode == 401) {
      final dynamic status = jsonBody['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw const ApiClientException(type: ApiClientExceptionType.auth);
      }
      if (code == 3) {
        throw const ApiClientException(type: ApiClientExceptionType.sessionExpired);
      }
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
  }
}
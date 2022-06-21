import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../entity/movie_details.dart';
import '../entity/popular_movie_response.dart';

enum ApiClientExceptionType {
  network,
  auth,
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

class ApiClient {
  static const _host = 'https://api.themoviedb.org/3';
  static const _apiKey = '03bf18a1588eb1f64c6692e2ed80e646';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const username = 'Artur786746546';
  static const password = 'KXZPW!pa6xL5cdM';

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

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final requestToken = jsonResponse['request_token'] as String;

      return requestToken;
    } else if (response.statusCode == 401) {
      throw const ApiClientException(
          type: ApiClientExceptionType.other); // Ошибка неверного токена.
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
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
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);

      return popularMovieResponse;
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
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
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);
      return popularMovieResponse;
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
  }

    Future<MovieDetails> movieDetails(
      int movieId, String locale) async {
    var url = _makeUri(
      '/movie/$movieId',
      <String, dynamic>{
        'api_key': _apiKey,
        'language': locale,
      },
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final movieDetails = MovieDetails.fromJson(jsonResponse);
      return movieDetails;
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
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

    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final requestToken = jsonResponse['request_token'] as String;
      return requestToken;
    } else if (response.statusCode == 401) {
      throw const ApiClientException(
          type: ApiClientExceptionType.auth); // Ошибка авторизации.
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
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

    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final sessionId = jsonResponse['session_id'] as String;
      return sessionId;
    } else if (response.statusCode == 401) {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    } else {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }
  }
}

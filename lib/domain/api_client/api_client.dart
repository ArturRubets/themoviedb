import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../../configuration/configuration.dart';
import '../entity/movie_details.dart';
import '../entity/popular_movie_response.dart';
import 'network_client.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

  static const username = '';
  static const password = '';

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    var url = _networkClient.makeUri(
      '/movie/popular',
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'language': locale,
        'page': page.toString(),
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);

    return popularMovieResponse;
  }

  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query) async {
    var url = _networkClient.makeUri(
      '/search/movie',
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'language': locale,
        'page': page.toString(),
        'query': query,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final popularMovieResponse = PopularMovieResponse.fromJson(jsonResponse);

    return popularMovieResponse;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    var url = _networkClient.makeUri(
      '/movie/$movieId',
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final movieDetails = MovieDetails.fromJson(jsonResponse);

    return movieDetails;
  }

  Future<bool?> isFavorite(int movieId, String sessionId) async {
    var url = _networkClient.makeUri(
      '/movie/$movieId/account_states',
      <String, dynamic>{
        'session_id': sessionId,
        'api_key': Configuration.apiKey,
      },
    );

    var response = await http.get(url);

    final jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    _networkClient.validateResponse(response.statusCode, jsonResponse);

    final result = jsonResponse['favorite'] as bool?;

    return result;
  }
}

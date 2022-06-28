import '../../configuration/configuration.dart';
import '../api_client/account_api_client.dart';
import '../api_client/api_client.dart';
import '../data_provider/session_data_provider.dart';
import '../entity/popular_movie_response.dart';
import '../local_entity/movie_details_local.dart';

class MoviesService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(
        page,
        locale,
        Configuration.apiKey,
      );

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async =>
      _movieApiClient.searchMovie(
        page,
        locale,
        query,
        Configuration.apiKey,
      );

  Future<MovieDetailLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.sessionId;
    bool? isFavorite;
    if (sessionId != null) {
      isFavorite =
          await _movieApiClient.isFavorite(movieId, sessionId) ?? false;
    }

    return MovieDetailLocal(movieDetails: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final sessionId = await _sessionDataProvider.sessionId;
    final accountId = await _sessionDataProvider.accountId;

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavotite(
      accountId: accountId,
      sessionId: sessionId,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}

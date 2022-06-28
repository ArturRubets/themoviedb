// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/entity/movie_details.dart';
import '../../../domain/services/auth_service.dart';
import '../../../domain/services/movies_service.dart';
import '../../../library/localized_model_storage.dart';
import '../../navigation/main_navigation.dart';

class MovieDetailsPosterData {
  MovieDetailsPosterData({
    required this.backdropPath,
    required this.posterPath,
    required this.isFavorite,
    required this.iconFavorite,
  });

  final String? backdropPath;
  final String? posterPath;
  bool isFavorite;
  IconData iconFavorite;

  void updateIsFavorite(bool isFavorite) {
    this.isFavorite = isFavorite;
    iconFavorite = isFavorite == true ? Icons.favorite : Icons.favorite_border;
  }
}

class MovieDetailsScoreData {
  MovieDetailsScoreData({
    required this.scoreForRadialWidget,
    required this.scoreForLabel,
  });

  final double? scoreForRadialWidget;
  final String? scoreForLabel;
}

class MovieDetailsPersonData {
  MovieDetailsPersonData({
    required this.name,
    required this.department,
  });

  final String name;
  final String department;
}

class MovieDetailsCastData {
  MovieDetailsCastData({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final String name;
  final String character;
  final String? profilePath;
}

class MovieDetailsData {
  MovieDetailsData({
    required this.title,
    required this.isLoading,
    required this.overview,
    required this.poster,
    required this.year,
    required this.score,
    required this.trailerKey,
    required this.summary,
    required this.fourPeopleOfDoubleChunks,
    required this.movieDetailsCastData,
  });

  factory MovieDetailsData.fromMovieDetail(
    MovieDetails? movieDetails,
    bool? isFavorite,
    String Function(DateTime datetime) stringFromDate,
  ) {
    String makeSummary(String Function(DateTime datetime) stringFromDate) {
      final texts = <String>[];
      final releaseDate = movieDetails?.releaseDate;
      if (releaseDate != null) {
        texts.add(stringFromDate(releaseDate));
      }
      final productionCountries = movieDetails?.productionCountries;
      if (productionCountries != null && productionCountries.isNotEmpty) {
        texts.add('(${productionCountries.first.iso})');
      }
      texts.add('•');
      final runtime = movieDetails?.runtime;
      if (runtime != null && runtime != 0) {
        final duration = Duration(minutes: runtime);
        final hours = duration.inHours;
        final minutes = runtime - hours * 60;
        texts.add('${hours}h ${minutes}m');
      }

      final genres = movieDetails?.genres.map((g) => g.name);
      if (genres != null && genres.isNotEmpty) {
        texts.add(genres.join(', '));
      }

      final text = texts.join(' ');
      return text;
    }

    List<List<T>> listToChunks<T>(List<T> list, int chunkSize) {
      var chunks = <List<T>>[];

      for (var i = 0; i < list.length; i += chunkSize) {
        final chunk = list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        );
        chunks.add(chunk);
      }
      return chunks;
    }

    final title = movieDetails?.title ?? 'Загрузка...';
    final isLoading = movieDetails == null;
    final overview = movieDetails?.overview;

    final iconFavorite =
        isFavorite == true ? Icons.favorite : Icons.favorite_border;
    final poster = MovieDetailsPosterData(
      backdropPath: movieDetails?.backdropPath,
      posterPath: movieDetails?.posterPath,
      isFavorite: isFavorite ?? false,
      iconFavorite: iconFavorite,
    );

    var year = movieDetails?.releaseDate?.year.toString();
    year = year == null ? '' : ' ($year)';

    final voteAverage = movieDetails?.voteAverage;
    double? scoreForRadialWidget;
    String? scoreForLabel;
    if (voteAverage != null) {
      scoreForRadialWidget = voteAverage / 10;
      scoreForLabel = '${(voteAverage * 10).toInt()}';
    }
    final score = MovieDetailsScoreData(
      scoreForRadialWidget: scoreForRadialWidget,
      scoreForLabel: scoreForLabel,
    );

    final videos = movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube')
        .toList();
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    final summary = makeSummary(stringFromDate);

    final peopleOfDoubleChunks = <MovieDetailsPersonData>[];
    var crew = movieDetails?.credits.crew;
    if (crew != null) {
      crew.sort(
        (a, b) => ((b.popularity - a.popularity) * 100).toInt(),
      ); // descending popularity
      crew = crew.take(4).toList(); // 4 of the best popularity
      for (final c in crew) {
        peopleOfDoubleChunks.add(
            MovieDetailsPersonData(name: c.name, department: c.department));
      }
    }
    final fourPeopleOfDoubleChunks = listToChunks(peopleOfDoubleChunks, 2);

    final fourOfCast = movieDetails?.credits.cast.take(4).toList();
    final movieDetailsCastData = fourOfCast
            ?.map(
              (c) => MovieDetailsCastData(
                name: c.name,
                character: c.character,
                profilePath: c.profilePath,
              ),
            )
            .toList() ??
        [];

    return MovieDetailsData(
      title: title,
      isLoading: isLoading,
      overview: overview,
      poster: poster,
      year: year,
      score: score,
      trailerKey: trailerKey,
      summary: summary,
      fourPeopleOfDoubleChunks: fourPeopleOfDoubleChunks,
      movieDetailsCastData: movieDetailsCastData,
    );
  }

  final String title;
  final bool isLoading;
  final String? overview;
  final MovieDetailsPosterData poster;
  final String year;
  final MovieDetailsScoreData score;
  final String? trailerKey;
  final String summary;
  final List<List<MovieDetailsPersonData>> fourPeopleOfDoubleChunks;
  final List<MovieDetailsCastData> movieDetailsCastData;
}

class MovieDetailsModel extends ChangeNotifier {
  MovieDetailsModel(this.movieId);
  late MovieDetailsData data;

  final _authService = AuthService();
  final _moviesService = MoviesService();

  final int movieId;
  final _localeStorage = LocalizedModelStorage();
  DateFormat? _dateFormat;

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    final isUpdate = _localeStorage.updateLocale(locale);
    if (!isUpdate) return;

    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateMovieDetailsData(null, null);
    await loadDetails(context);
  }

  String stringFromDate(DateTime? date) =>
      date == null ? '' : _dateFormat!.format(date);

  void updateMovieDetailsData(MovieDetails? movieDetails, bool? isFavorite) {
    data = MovieDetailsData.fromMovieDetail(
        movieDetails, isFavorite, stringFromDate);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await _moviesService.loadDetails(
          movieId: movieId, locale: _localeStorage.localeTag);
      updateMovieDetailsData(details.movieDetails, details.isFavorite);
      notifyListeners();
    } on ApiClientException catch (e) {
      await _handleApiClientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final newFavoriteValue = !data.poster.isFavorite;
    try {
      await _moviesService.updateFavorite(
        movieId: movieId,
        isFavorite: newFavoriteValue,
      );
      data.poster.updateIsFavorite(newFavoriteValue);
      notifyListeners();
    } on ApiClientException catch (e) {
      await _handleApiClientException(e, context);
    }
  }

  Future<void> _handleApiClientException(
      ApiClientException exception, BuildContext context) async {
    if (exception.type == ApiClientExceptionType.sessionExpired) {
      await _authService.logout();
      await MainNavigation.resetNavigation(context);
    }
  }
}

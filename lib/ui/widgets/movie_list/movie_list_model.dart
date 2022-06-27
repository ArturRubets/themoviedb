import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/movie.dart';
import '../../../domain/services/movies_service.dart';
import '../../../library/paginator.dart';
import '../../navigation/main_navigation.dart';

class MovieListRowData {
  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });

  factory MovieListRowData.fromMovie(Movie movie, DateFormat dateFormat) {
    final releaseDate = movie.releaseDate;

    final String releaseDateString =
        releaseDate == null ? '' : dateFormat.format(releaseDate);

    return MovieListRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      releaseDate: releaseDateString,
      overview: movie.overview,
    );
  }

  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;
}

class MovieListViewModel extends ChangeNotifier {
  MovieListViewModel() {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result = await _moviesService.popularMovie(page, _locale);
      return PaginatorLoadResult(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });

    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result = await _moviesService.searchMovie(
        page,
        _locale,
        _searchQuery ?? '',
      );
      return PaginatorLoadResult(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });
  }

  final _moviesService = MoviesService();
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  var _movies = <MovieListRowData>[];
  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';
  String? _searchQuery;
  bool get isSearchMode => _searchQuery != null && _searchQuery!.isNotEmpty;
  Timer? searchDebounce;

  Future<void> setupLocale(BuildContext context) async {
    String locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data
          .map((movie) => MovieListRowData.fromMovie(movie, _dateFormat))
          .toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data
          .map((movie) => MovieListRowData.fromMovie(movie, _dateFormat))
          .toList();
    }
    notifyListeners();
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 600), () async {
      if (_searchQuery == text) return;
      _searchQuery = text.isEmpty ? null : text;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      await _loadNextPage();
    });
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}

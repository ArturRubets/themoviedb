import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../domain/entity/movie.dart';
import '../../../domain/entity/popular_movie_response.dart';
import '../../navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);
   DateFormat? _dateFormat;
  String _locale = 'en-GB';
  int _currentPage = 0;
  int _totalPage = 1;
  bool _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? searchDebounce;

  String stringFromDate(DateTime? date) =>
      date == null ? '' : _dateFormat!.format(date);

  Future<void> setupLocale(BuildContext context) async {
    _locale = Localizations.localeOf(context).toLanguageTag();
    _dateFormat = DateFormat.yMMMMd(_locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await _loadMovies();
  }

  Future<PopularMovieResponse> _downloadType(
      int nextPage, String locale) async {
    if (_searchQuery == null) {
      return await _apiClient.popularMovie(nextPage, _locale);
    } else {
      return await _apiClient.searchMovie(nextPage, locale, _searchQuery!);
    }
  }

  Future<void> _loadMovies() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final moviesResponse = await _downloadType(nextPage, _locale);
      _movies.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 600), () async {
      if (_searchQuery == text) return;
      _searchQuery = text.isEmpty ? null : text;
      await _resetList();
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
    _loadMovies();
  }
}

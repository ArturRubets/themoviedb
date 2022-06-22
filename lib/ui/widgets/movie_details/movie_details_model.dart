import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../domain/data_provider/session_data_provider.dart';
import '../../../domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  MovieDetailsModel(BuildContext context, {required this.movieId}) {
    setupLocale(context);
  }

  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final int movieId;
  String _locale = 'en-GB';
  MovieDetails? _movieDetails;
  DateFormat? _dateFormat;
  bool _isFavorite = false;

  MovieDetails? get movieDetails => _movieDetails;
  bool get isFavorite => _isFavorite;

  String stringFromDate(DateTime? date) =>
      date == null ? '' : _dateFormat!.format(date);

  Future<void> loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    final sessionId = await _sessionDataProvider.sessionId;
    if (sessionId != null) {
      _isFavorite = await _apiClient.isFavorite(movieId, sessionId) ?? false;
    }
    notifyListeners();
  }

  Future<void> setupLocale(BuildContext context) async {
    _locale = Localizations.localeOf(context).toLanguageTag();
    _dateFormat = DateFormat.yMMMMd(_locale);
    await loadDetails();
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.sessionId;
    final accountId = await _sessionDataProvider.accountId;

    if (sessionId == null || accountId == null) return;

    final newFavoriteValue = !_isFavorite;

    final response = await _apiClient.markAsFavotite(
      accountId: accountId,
      sessionId: sessionId,
      mediaId: movieId,
      isFavorite: newFavoriteValue,
    );

    if (response) {
      _isFavorite = newFavoriteValue;
      notifyListeners();
    }
  }
}

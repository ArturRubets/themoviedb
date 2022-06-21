import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  MovieDetailsModel({required this.movieId});

  final _apiClient = ApiClient();

  final int movieId;
  String _locale = 'en-GB';
  MovieDetails? _movieDetails;
  DateFormat? _dateFormat;

  MovieDetails? get movieDetails => _movieDetails;

  String stringFromDate(DateTime? date) =>
      date == null ? '' : _dateFormat!.format(date);

  Future<void> loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }

  Future<void> setupLocale(BuildContext context) async {
    _locale = Localizations.localeOf(context).toLanguageTag();
    _dateFormat = DateFormat.yMMMMd(_locale);
    await loadDetails();
  }
}

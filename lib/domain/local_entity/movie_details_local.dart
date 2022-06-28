import '../entity/movie_details.dart';

class MovieDetailLocal {
  MovieDetailLocal({
    required this.movieDetails,
    required this.isFavorite,
  });

  final MovieDetails movieDetails;
  final bool? isFavorite;
}

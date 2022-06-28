import 'package:flutter/material.dart';

import '../../domain/factories/screen_factory.dart';

abstract class MainNavigationRouteNames {
  static const loaderScreen = '/';
  static const auth = '/auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/main_screen/movie_details';
  static const movieTrailerWidget = '/main_screen/movie_details/trailer';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderScreen: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieDetails(movieId),
        );
      case MainNavigationRouteNames.movieTrailerWidget:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieTrailer(youTubeKey),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Navigation error'),
        );
    }
  }

  static Future<void> resetNavigation(BuildContext context) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderScreen,
      (route) => false,
    );
  }
}

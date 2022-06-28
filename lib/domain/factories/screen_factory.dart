import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/widgets/auth/auth_model.dart';
import '../../ui/widgets/auth/auth_widget.dart';
import '../../ui/widgets/loader_widget/loader_view_model.dart';
import '../../ui/widgets/loader_widget/loader_widget.dart';
import '../../ui/widgets/main_screen/main_screen_widget.dart';
import '../../ui/widgets/movie_details/movie_details_model.dart';
import '../../ui/widgets/movie_details/movie_details_widget.dart';
import '../../ui/widgets/movie_list/movie_list_model.dart';
import '../../ui/widgets/movie_list/movie_list_widget.dart';
import '../../ui/widgets/movie_trailer/movie_trailer_widget.dart';
import '../../ui/widgets/news/news_screen_widget.dart';
import '../../ui/widgets/tv_show/tv_show_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String youTubeKey) {
    return MovieTrailerWidget(youTubeKey: youTubeKey);
  }

  Widget makeNewsList() {
    return const NewsWidget();
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVShowList() {
    return const TVShowWidget();
  }
}

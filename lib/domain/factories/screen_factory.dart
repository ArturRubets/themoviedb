import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/widgets/inherited/provider.dart' as old_provider;
import '../../ui/widgets/app/my_app_model.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MyAppModel()),
      ],
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return ChangeNotifierProvider(
      create: (_) => MyAppModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget makeMovieDetails(BuildContext context, int movieId) {
    return old_provider.NotifierProvider(
      create: () => MovieDetailsModel(context, movieId: movieId),
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

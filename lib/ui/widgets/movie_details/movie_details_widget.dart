import 'package:flutter/material.dart';

import '../../../library/widgets/inherited/provider.dart';
import 'movie_details_main_info_widget.dart';
import 'movie_details_main_screen_cast_widget.dart';
import 'movie_details_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final title = model?.movieDetails?.title;

    const circularProgressIndicator = Center(
      child: CircularProgressIndicator(),
    );

    final listView = ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        MovieDetailsMainScreenCastWidget(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Загрузка...'),
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1),
        child:
            model?.movieDetails == null ? circularProgressIndicator : listView,
      ),
    );
  }
}

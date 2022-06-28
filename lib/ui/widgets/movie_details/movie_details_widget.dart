import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<MovieDetailsModel>().setupLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    final title =
        context.select<MovieDetailsModel, String>((model) => model.data.title);

    final isLoading = context
        .select<MovieDetailsModel, bool>((model) => model.data.isLoading);

    const circularProgressIndicator =
        Center(child: CircularProgressIndicator());

    final listView = ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        MovieDetailsMainScreenCastWidget(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1),
        child: isLoading ? circularProgressIndicator : listView,
      ),
    );
  }
}

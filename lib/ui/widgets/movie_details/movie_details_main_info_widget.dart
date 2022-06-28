// ignore_for_file: avoid_types_on_closure_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_client/image_downloader.dart';
import '../../navigation/main_navigation.dart';
import '../elements/radial_percent_widget.dart';
import 'movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopPostersWidget(),
        Padding(
          padding: EdgeInsets.all(20),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: EdgeInsets.all(10),
          child: _OverViewWidget(),
        ),
        _DescriptionWidget(),
        SizedBox(height: 30),
        _PeopleWidgets(),
        SizedBox(height: 20),
      ],
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final poster =
        context.select((MovieDetailsModel value) => value.data.poster);

    final backdropPath = poster.backdropPath;
    final posterPath = poster.posterPath;
    final iconFavorite = context
        .select((MovieDetailsModel value) => value.data.poster.iconFavorite);

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 5 / 3,
        child: Stack(
          children: [
            if (backdropPath != null)
              Image.network(ImageDownloader.imageUrl(backdropPath)),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(10, 0),
                      blurRadius: 5,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 110,
              top: 0,
              bottom: 0,
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(10, 0),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
            if (posterPath != null)
              Positioned(
                left: 20,
                top: 0,
                bottom: 30,
                child: Image.network(ImageDownloader.imageUrl(posterPath)),
              ),
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: IconButton(
                  color: Colors.red,
                  icon: Icon(iconFavorite),
                  onPressed: () => model.toggleFavorite(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.read<MovieDetailsModel>().data;
    final title = data.title;
    final year = data.year;

    return RichText(
      maxLines: 3,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: year,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  void navigateToTrailer(BuildContext context, String trailerKey) =>
      Navigator.of(context).pushNamed(
          MainNavigationRouteNames.movieTrailerWidget,
          arguments: trailerKey);

  @override
  Widget build(BuildContext context) {
    final score = context.read<MovieDetailsModel>().data.score;
    final scoreForLabel = score.scoreForLabel;
    final scoreForRadialWidget = score.scoreForRadialWidget;
    final trailerKey = context.read<MovieDetailsModel>().data.trailerKey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              if (scoreForLabel != null && scoreForRadialWidget != null)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: RadialPercentWidget(
                    percent: scoreForRadialWidget,
                    fillColor: const Color(0xFF201F20),
                    lineColor: const Color(0xFF21D07A),
                    freeColor: const Color(0xFF20452A),
                    lineWidth: 3,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 2,
                          top: 5,
                          child: Text(
                            scoreForLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 5,
                          right: -1,
                          child: Text(
                            '%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              const Text(
                'User Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(color: Colors.grey, width: 1, height: 20),
        if (trailerKey != null)
          TextButton(
            onPressed: () => navigateToTrailer(context, trailerKey),
            child: Row(
              children: const [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  ' Play Trailer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = context.read<MovieDetailsModel>().data.summary;

    return ColoredBox(
      color: const Color.fromRGBO(20, 20, 20, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 40,
        ),
        child: Text(
          summary,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _OverViewWidget extends StatelessWidget {
  const _OverViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Overview',
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview = context.read<MovieDetailsModel>().data.overview;
    if (overview == null || overview.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        overview,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _PeopleWidgets extends StatelessWidget {
  const _PeopleWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    const jobTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    final fourPeopleOfDoubleChunks =
        context.read<MovieDetailsModel>().data.fourPeopleOfDoubleChunks;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: List.generate(
          fourPeopleOfDoubleChunks.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fourPeopleOfDoubleChunks[index][0].name,
                          style: nameStyle),
                      Text(fourPeopleOfDoubleChunks[index][0].department,
                          style: jobTitleStyle),
                    ],
                  ),
                ),
                if (fourPeopleOfDoubleChunks[index].length == 2)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fourPeopleOfDoubleChunks[index][1].name,
                            style: nameStyle),
                        Text(fourPeopleOfDoubleChunks[index][1].department,
                            style: jobTitleStyle),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

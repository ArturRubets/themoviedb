import 'package:flutter/material.dart';

import '../../../domain/api_client/image_downloader.dart';
import '../../../library/widgets/inherited/provider.dart';
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
        Padding(
          padding: EdgeInsets.all(10),
          child: _DescriptionWidget(),
        ),
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    final isFavorite = model?.isFavorite;
    final iconFavorite =
        isFavorite == true ? Icons.favorite : Icons.favorite_border;
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
                  onPressed: () => model?.toggleFavorite(context),
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final title = model?.movieDetails?.title;
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year == null ? '' : ' ($year)';
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final score = model?.movieDetails?.voteAverage;

    double? radialPercentWidget1;
    int? radialPercentWidget2;
    if (score != null) {
      radialPercentWidget1 = score / 10;
      radialPercentWidget2 = (score * 10).toInt();
    }

    final videos = model?.movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube')
        .toList();

    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              if (radialPercentWidget1 != null && radialPercentWidget2 != null)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: RadialPercentWidget(
                    percent: radialPercentWidget1,
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
                            '$radialPercentWidget2',
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();

    final texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    texts.add('•');
    final runtime = model.movieDetails?.runtime;
    if (runtime != null) {
      final duration = Duration(minutes: runtime);
      final hours = duration.inHours;
      final minutes = runtime - hours * 60;
      texts.add('${hours}h ${minutes}m');
    }

    final genres = model.movieDetails?.genres.map((g) => g.name);
    if (genres != null && genres.isNotEmpty) {
      texts.add(genres.join(', '));
    }

    final text = texts.join(' ');
    return ColoredBox(
      color: const Color.fromRGBO(20, 20, 20, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 40,
        ),
        child: Text(
          text,
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final overview = model?.movieDetails?.overview ?? '';
    return Text(
      overview,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
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
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null) return const SizedBox.shrink();
    crew.sort((a, b) =>
        ((b.popularity - a.popularity) * 100).toInt()); // descending popularity
    crew = crew.take(4).toList(); // 4 of the best popularity

    // Characters
    // Director
    // Writer

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crew[0].name, style: nameStyle),
                    Text(crew[0].department, style: jobTitleStyle),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crew[1].name, style: nameStyle),
                    Text(crew[1].department, style: jobTitleStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crew[2].name, style: nameStyle),
                    Text(crew[2].department, style: jobTitleStyle),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crew[3].name, style: nameStyle),
                    Text(crew[3].department, style: jobTitleStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_client/image_downloader.dart';
import 'movie_list_model.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieListViewModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _MovieList(),
        _Search(),
      ],
    );
  }
}

class _Search extends StatelessWidget {
  const _Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model.searchMovie,
        decoration: InputDecoration(
          labelText: 'Поиск',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _MovieList extends StatelessWidget {
  const _MovieList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListViewModel>();

    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(top: 70),
        itemCount: model.movies.length,
        itemExtent: 163,
        itemBuilder: (context, index) {
          model.showedMovieAtIndex(index);
          return _MovieListRow(index);
        });
  }
}

class _MovieListRow extends StatelessWidget {
  const _MovieListRow(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    final movie = model.movies[index];
    var posterPath = movie.posterPath;
    posterPath ??= '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                if (posterPath.isNotEmpty)
                  Image.network(ImageDownloader.imageUrl(posterPath)),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => model.onMovieTap(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_client/image_downloader.dart';
import 'movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Top Billed Cast',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          showCasts(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {},
              child: const Text(
                'Full Cast & Crew',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showCasts(BuildContext context) {
    final cast = context.read<MovieDetailsModel>().data.movieDetailsCastData;
    
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 240,
        child: Scrollbar(
          child: ListView.builder(
            itemExtent: 140,
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String name = cast[index].name;
              String character = cast[index].character;
              String? profilePath = cast[index].profilePath;
              String? profilePathUrl;
              if (profilePath != null) {
                profilePathUrl = ImageDownloader.imageUrl(profilePath);
              }

              return Container(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.only(left: 10, right: 4),
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profilePathUrl != null)
                      AspectRatio(
                        aspectRatio: 8 / 9,
                        child: Image.network(
                          profilePathUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 10,
                        right: 10,
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        character,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

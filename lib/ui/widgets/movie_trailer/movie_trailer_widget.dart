import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatelessWidget {
  const MovieTrailerWidget({
    Key? key,
    required this.youTubeKey,
  }) : super(key: key);

  final String youTubeKey;

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: youTubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    final youtubePlayer = YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {},
    );

    return YoutubePlayerBuilder(
        player: youtubePlayer,
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                player,
              ],
            ),
          );
        });
  }
}

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/widgets/one_image.dart';
import 'package:one_music/theme/theme_extensions.dart';

import '../../controller/one_player_controller.dart';

class PlayerWidget extends StatelessWidget {
  final void Function()? onLeft;
  final void Function()? onPlay;
  final void Function()? onRight;
  final void Function()? onTapCard;
  final OneSong song;
  final bool isPlaying;
  PlayerWidget({
    super.key,
    this.onLeft,
    this.onPlay,
    this.onRight,
    required this.song,
    this.onTapCard,
    required this.isPlaying,
  });

  final OnePlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: InkWell(
        onTap: onTapCard,
        child: Container(
          height: 75,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.colorScheme.onSecondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  OneImage(picture: song.picture, size: OneImageSize.small),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song.title, overflow: TextOverflow.ellipsis),
                        Text(
                          song.artist,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: onLeft,
                    child: Icon(Icons.skip_previous, size: 30),
                  ),
                  InkWell(
                    onTap: onPlay,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    onTap: onRight,
                    child: Icon(Icons.skip_next, size: 30),
                  ),
                ],
              ),
              Spacer(),
              StreamBuilder(
                stream: controller.player.positionStream,
                builder: (context, snapshot) {
                  return ProgressBar(
                    timeLabelPadding: 0,
                    progress: snapshot.data ?? Duration.zero,
                    total: controller.player.duration ?? Duration.zero,
                    timeLabelLocation: TimeLabelLocation.none,
                    thumbRadius: 0,
                    barHeight: 3,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

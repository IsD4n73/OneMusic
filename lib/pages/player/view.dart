import 'dart:convert';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/widgets/one_image.dart';

import '../../controller/one_player_controller.dart';
import 'logic.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({super.key});

  final PlayerLogic logic = Get.put(PlayerLogic());
  final OnePlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OneImage(
                picture: controller.playingSong.value!.picture!,
                size: OneImageSize.big,
              ),
              SizedBox(height: 10),
              Text(
                controller.playingSong.value?.title ?? "not_playing".tr(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                controller.playingSong.value?.artist ?? "",
                textAlign: TextAlign.center,
              ),
              Divider(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder(
                  stream: controller.player.positionStream,
                  builder: (context, snapshot) {
                    return ProgressBar(
                      progress: snapshot.data ?? Duration.zero,
                      total: controller.player.duration ?? Duration.zero,
                      timeLabelLocation: TimeLabelLocation.above,
                      onSeek: (duration) {
                        Get.log('User selected a new time: $duration');
                        controller.player.seek(duration);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
                  IconButton(
                    onPressed: () async {
                      var songs = controller.getPlayerSource();
                      await controller.previousSong(songs);
                    },
                    icon: Icon(Icons.skip_previous),
                    style: IconButton.styleFrom(iconSize: 50),
                  ),
                  StreamBuilder(
                    stream: controller.player.playingStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: () {
                          controller.togglePlaySong();
                        },
                        icon: Icon(
                          snapshot.data! ? Icons.pause : Icons.play_arrow,
                        ),
                        style: IconButton.styleFrom(iconSize: 50),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      var songs = controller.getPlayerSource();
                      await controller.nextSong(songs);
                    },
                    icon: Icon(Icons.skip_next),
                    style: IconButton.styleFrom(iconSize: 50),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.timer)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/models/one_playlist.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/widgets/song_tile.dart';

import '../../controller/one_player_controller.dart';
import '../player/view.dart';
import '../widgets/one_app_bar.dart';
import '../widgets/one_image.dart';
import '../widgets/player_widget.dart';
import 'logic.dart';

class PlaylistDetailsPage extends StatelessWidget {
  final OnePlaylist playlist;
  PlaylistDetailsPage({super.key, required this.playlist});

  late final PlaylistDetailsLogic logic = Get.put(
    PlaylistDetailsLogic(playlist.songs),
  );
  final OnePlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OneAppBar(
            textOne: "${playlist.name.tr()} |",
            textTwo: "(${playlist.songs.length}) ${"tracks".tr()}",
          ),

          SizedBox(height: 20),
          OneImage(picture: playlist.picture, size: OneImageSize.medium),
          SizedBox(height: 20),
          Text(
            playlist.name.tr(),
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text("${playlist.songs.length} ${"tracks".tr()}"),
          Divider(),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlist.songs.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => SongTile(
                        song: OneSong.fromJson(
                          jsonDecode(playlist.songs[index]),
                        ),
                        onTap: () async {
                          if (controller.playingSong.value?.file ==
                              logic.songs[index].file) {
                            controller.isPlaying.value =
                                !controller.player.playing;
                            controller.togglePlaySong();
                            return;
                          }

                          List<OneSong> tmpSongs = [];

                          for (var element in logic.songs) {
                            tmpSongs.add(element.copyWith(selected: false));
                          }

                          logic.songs.clear();
                          logic.songs.addAll(tmpSongs);

                          logic.songs[index] = logic.songs[index].copyWith(
                            selected: true,
                          );

                          controller.playingSong.value = logic.songs[index];

                          controller.isPlaying.value = true;

                          await controller.loadPlaylist(logic.songs, index);
                        },
                        isPlaying: true,
                        isSelected:
                            controller.playingSong.value?.file ==
                            logic.songs[index].file,
                        onLongTap: (position) {},
                      ),
                    );
                  },
                ),
                Obx(
                  () => controller.playingSong.value != null
                      ? PlayerWidget(
                          song: controller.playingSong.value!,
                          isPlaying: controller.isPlaying.value,
                          onLeft: () async {
                            var updatedSongs = await controller.previousSong(
                              logic.songs,
                            );
                            logic.songs.value = updatedSongs;
                          },
                          onPlay: () {
                            controller.isPlaying.value =
                                !controller.player.playing;
                            controller.togglePlaySong();
                          },
                          onRight: () async {
                            var updatedSongs = await controller.nextSong(
                              logic.songs,
                            );
                            logic.songs.value = updatedSongs;
                          },
                          onTapCard: () {
                            Get.to(() => PlayerPage());
                          },
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

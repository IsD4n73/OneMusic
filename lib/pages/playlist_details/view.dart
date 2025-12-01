import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/models/one_playlist.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/widgets/song_tile.dart';

import '../../controller/one_player_controller.dart';
import '../widgets/one_app_bar.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            OneAppBar(
              textOne: "${playlist.name} |",
              textTwo: "(${playlist.songs.length}) ${"track".tr()}",
            ),
            SizedBox(height: 20),
            playlist.picture != null
                ? Image.memory(
                    base64Decode(playlist.picture!),
                    width: 150,
                    height: 150,
                  )
                : Image.asset(
                    "assets/images/icon.png",
                    width: 150,
                    height: 150,
                  ),
            SizedBox(height: 20),
            Text(
              playlist.name,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text("${playlist.songs.length} ${"track".tr()}"),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: playlist.songs.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Obx(
                  () => SongTile(
                    song: OneSong.fromJson(jsonDecode(playlist.songs[index])),
                    onTap: () async {
                      if (controller.playingSong.value?.file ==
                          logic.songs[index].file) {
                        controller.isPlaying.value = !controller.player.playing;
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
          ],
        ),
      ),
    );
  }
}

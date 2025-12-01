import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/playlist/view.dart';
import 'package:one_music/pages/songs/view.dart';
import 'package:one_music/pages/widgets/one_app_bar.dart';
import 'package:one_music/pages/widgets/one_error_widget.dart';
import 'package:one_music/pages/widgets/playlist_tile.dart';
import 'package:one_music/pages/widgets/song_tile.dart';
import '../../controller/one_player_controller.dart';
import '../../models/one_song.dart';
import '../playlist_details/view.dart';
import 'logic.dart';

class SearchPage extends StatelessWidget {
  final Type coming;
  SearchPage({super.key, required this.coming});

  final SearchLogic logic = Get.put(SearchLogic());
  final OnePlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.log("coming: $coming");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OneAppBar(
                textOne: "search".tr(),
                textTwo: coming == SongsPage ? "songs".tr() : "playlists".tr(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: logic.searchController,
                onChanged: (value) => logic.search(value, coming),
                decoration: InputDecoration(
                  labelText: "search".tr(),
                  hintText: "search".tr(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Divider(),
              Obx(
                () => (coming == SongsPage && logic.songs.isEmpty)
                    ? OneErrorWidget(error: "no_songs_found")
                    : (coming == PlaylistPage && logic.playlist.isEmpty)
                    ? OneErrorWidget(error: "no_playlists_found")
                    : SizedBox.shrink(),
              ),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: coming == SongsPage
                      ? logic.songs.length
                      : logic.playlist.length,
                  itemBuilder: (context, index) {
                    if (coming == SongsPage) {
                      return SongTile(
                        song: logic.songs[index],
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
                      );
                    }
                    return PlaylistTile(
                      playlist: logic.playlist[index],
                      onTap: () {
                        Get.to(
                          () => PlaylistDetailsPage(
                            playlist: logic.playlist[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

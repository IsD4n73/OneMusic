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
import '../../controller/yt_player_controller.dart';
import '../../models/one_song.dart';
import '../playlist_details/view.dart';
import 'logic.dart';

class SearchPage extends StatelessWidget {
  final Type coming;
  SearchPage({super.key, required this.coming});

  final SearchLogic logic = Get.put(SearchLogic());
  final OnePlayerController controller = Get.find();
  final YtPlayerController ytController = Get.find();

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
                onChanged: (value) {
                  logic.search(value, coming);
                  ytController.search(value, coming != SongsPage);
                },
                decoration: InputDecoration(
                  labelText: "search".tr(),
                  hintText: "search".tr(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Divider(),
              Obx(
                () =>
                    ytController.searchResults.isEmpty &&
                        ytController.playlistResult.isEmpty
                    ? SizedBox.shrink()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: coming == SongsPage
                            ? ytController.searchResults.length
                            : ytController.playlistResult.length,
                        itemBuilder: (context, index) {
                          if (coming == SongsPage) {
                            return SongTile(
                              song: ytController.searchResults[index],
                              onTap: () async {
                                if (controller.playingSong.value?.file ==
                                    ytController.searchResults[index].file) {
                                  controller.isPlaying.value =
                                      !controller.player.playing;
                                  controller.togglePlaySong();
                                  return;
                                }

                                List<OneSong> tmpSongs = [];

                                for (var element
                                    in ytController.searchResults) {
                                  tmpSongs.add(
                                    element.copyWith(selected: false),
                                  );
                                }

                                ytController.searchResults.clear();
                                ytController.searchResults.addAll(tmpSongs);

                                ytController.searchResults[index] = ytController
                                    .searchResults[index]
                                    .copyWith(selected: true);

                                controller.playingSong.value =
                                    ytController.searchResults[index];

                                controller.isPlaying.value = true;

                                await controller.loadPlaylist(
                                  ytController.searchResults,
                                  index,
                                );
                              },
                              isPlaying: true,
                              isSelected:
                                  controller.playingSong.value?.file ==
                                  ytController.searchResults[index].file,
                              onLongTap: (position) {},
                            );
                          }
                          return PlaylistTile(
                            playlist: ytController.playlistResult[index],
                            onTap: () {
                              Get.to(
                                () => PlaylistDetailsPage(
                                  playlist: ytController.playlistResult[index],
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              Obx(
                () =>
                    ytController.searchResults.isEmpty &&
                        ytController.playlistResult.isEmpty &&
                        (coming == SongsPage && logic.songs.isEmpty)
                    ? OneErrorWidget(error: "no_songs_found")
                    : ytController.searchResults.isEmpty &&
                          ytController.playlistResult.isEmpty &&
                          (coming == PlaylistPage && logic.playlist.isEmpty)
                    ? OneErrorWidget(error: "no_playlists_found")
                    : SizedBox.shrink(),
              ),
              ytController.searchResults.isEmpty &&
                      ytController.playlistResult.isEmpty
                  ? SizedBox.shrink()
                  : Divider(),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/controller/one_player_controller.dart';
import 'package:one_music/controller/yt_player_controller.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/player/view.dart';
import 'package:one_music/pages/search/view.dart';
import 'package:one_music/pages/songs/song_context_menu.dart';
import 'package:one_music/pages/songs/song_edit_sheet.dart';
import 'package:one_music/pages/widgets/player_widget.dart';
import 'package:one_music/pages/widgets/one_app_bar.dart';
import 'package:one_music/pages/widgets/song_tile.dart';
import 'package:one_music/theme/theme_extensions.dart';

import '../widgets/one_error_widget.dart';
import 'logic.dart';

class SongsPage extends StatelessWidget {
  SongsPage({super.key});

  final SongsLogic logic = Get.put(SongsLogic());
  final OnePlayerController controller = Get.put(OnePlayerController());
  final YtPlayerController ytController = Get.put(YtPlayerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneAppBar(
          textOne: "your".tr(),
          textTwo: "songs".tr(),
          rightIcon: Icons.search,
          onTap: () {
            Get.to(() => SearchPage(coming: runtimeType));
          },
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Obx(
                          () => Text("${logic.songs.length} ${"track".tr()}"),
                        ),
                      ),
                      Obx(
                        () => logic.songs.isEmpty
                            ? OneErrorWidget(error: "no_songs_found".tr())
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: logic.songs.length,
                                itemBuilder: (context, index) {
                                  ever(controller.playingSong, (callback) {
                                    var tmpSong = logic.songs[index];
                                    logic.songs.removeAt(index);
                                    logic.songs.insert(index, tmpSong);
                                  });
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SongTile(
                                        song: logic.songs[index],
                                        isPlaying: true,
                                        isSelected:
                                            controller
                                                .playingSong
                                                .value
                                                ?.file ==
                                            logic.songs[index].file,
                                        onTap: () async {
                                          if (controller
                                                  .playingSong
                                                  .value
                                                  ?.file ==
                                              logic.songs[index].file) {
                                            controller.isPlaying.value =
                                                !controller.player.playing;
                                            controller.togglePlaySong();
                                            return;
                                          }

                                          List<OneSong> tmpSongs = [];

                                          for (var element in logic.songs) {
                                            tmpSongs.add(
                                              element.copyWith(selected: false),
                                            );
                                          }

                                          logic.songs.clear();
                                          logic.songs.addAll(tmpSongs);

                                          logic.songs[index] = logic
                                              .songs[index]
                                              .copyWith(selected: true);

                                          controller.playingSong.value =
                                              logic.songs[index];

                                          controller.isPlaying.value = true;

                                          await controller.loadPlaylist(
                                            logic.songs,
                                            index,
                                          );
                                        },
                                        onLongTap: (Offset position) {
                                          SongContextMenu.show(
                                            onEditMeta: () {
                                              logic.prefillFields(
                                                logic.songs[index],
                                              );

                                              Get.bottomSheet(
                                                SongEditSheet(
                                                  song: logic.songs[index],
                                                ),
                                                enableDrag: true,
                                                isDismissible: true,
                                              );
                                            },
                                            onDelete: () {
                                              Get.defaultDialog(
                                                title:
                                                    "delete_song_dialog_title"
                                                        .tr(),
                                                content: Text(
                                                  "delete_song_dialog_content"
                                                      .tr(),
                                                ),
                                                contentPadding: EdgeInsets.all(
                                                  8,
                                                ),
                                                actions: [
                                                  OutlinedButton(
                                                    style:
                                                        OutlinedButton.styleFrom(
                                                          foregroundColor: Get
                                                              .context!
                                                              .colorScheme
                                                              .onSurface,
                                                        ),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text("cancel".tr()),
                                                  ),
                                                  OutlinedButton(
                                                    style:
                                                        OutlinedButton.styleFrom(
                                                          side: BorderSide(
                                                            color: Get
                                                                .context!
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                    onPressed: () async {
                                                      logic.deleteSong(
                                                        logic.songs[index],
                                                      );
                                                    },
                                                    child: Text("confirm".tr()),
                                                  ),
                                                ],
                                              );
                                            },
                                            offset: position,
                                          );
                                        },
                                      ),
                                      index == (logic.songs.length - 1) &&
                                              controller.playingSong.value !=
                                                  null
                                          ? SizedBox(height: 70)
                                          : SizedBox.shrink(),
                                    ],
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
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
    );
  }
}

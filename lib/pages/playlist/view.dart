import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/playlist/playlist_context_menu.dart';
import 'package:one_music/pages/widgets/one_error_widget.dart';
import 'package:one_music/theme/theme_extensions.dart';

import '../../controller/one_player_controller.dart';
import '../../models/one_song.dart';
import '../playlist_details/view.dart';
import '../search/view.dart';
import '../widgets/one_app_bar.dart';
import 'logic.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({super.key});

  final PlaylistLogic logic = Get.put(PlaylistLogic());
  final OnePlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneAppBar(
          textOne: "your".tr(),
          textTwo: "playlists".tr(),
          rightIcon: Icons.search,
          onTap: () {
            Get.to(() => SearchPage(coming: runtimeType));
          },
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    logic.addPlaylist();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.playlist_add),
                        SizedBox(width: 10),
                        Text("create_playlist".tr()),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              Obx(
                () => logic.playlists.isEmpty
                    ? OneErrorWidget(error: "no_playlists_found")
                    : GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: logic.playlists.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => PlaylistDetailsPage(
                                  playlist: logic.playlists[index],
                                ),
                              );
                            },
                            onLongPressStart: (details) {
                              PlaylistContextMenu.showPlaylist(
                                onEditMeta: () {
                                  logic.playlistNameController.text =
                                      logic.playlists[index].name;

                                  logic.selectedSongs.clear();
                                  logic.selectedSongs.addAll(
                                    logic.playlists[index].songs.map(
                                      (e) => OneSong.fromJson(jsonDecode(e)),
                                    ),
                                  );

                                  logic.addPlaylist(
                                    edit: true,
                                    toDelete: logic.playlists[index].name,
                                  );
                                },
                                onDelete: () {
                                  Get.defaultDialog(
                                    title: "delete_playlist_dialog_title".tr(),
                                    contentPadding: EdgeInsets.all(8),
                                    content: Text(
                                      "delete_playlist_dialog_content".tr(),
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
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
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Get
                                                .context!
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        onPressed: () async {
                                          logic.deletePlaylist(
                                            logic.playlists[index].name,
                                          );
                                        },
                                        child: Text("confirm".tr()),
                                      ),
                                    ],
                                  );
                                },
                                offset: details.globalPosition,
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  logic.playlists[index].picture != null
                                      ? Image.memory(
                                          base64Decode(
                                            logic.playlists[index].picture!,
                                          ),
                                          width: 150,
                                          height: 150,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    "assets/images/icon.png",
                                                    width: 150,
                                                    height: 150,
                                                  ),
                                        )
                                      : Image.asset(
                                          "assets/images/icon.png",
                                          width: 150,
                                          height: 150,
                                        ),
                                  Text(
                                    logic.playlists[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "${logic.playlists[index].songs.length} ${"track".tr()}",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ],
    );
  }
}

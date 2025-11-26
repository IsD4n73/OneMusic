import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/playlist/playlist_song_tile.dart';
import 'package:one_music/theme/theme_extensions.dart';

import 'logic.dart';

class PlaylistAddDialog extends StatelessWidget {
  PlaylistAddDialog({super.key});

  final PlaylistLogic logic = Get.put(PlaylistLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => TextField(
            controller: logic.playlistNameController,
            onChanged: (value) {
              logic.checkPlaylistName();
            },
            decoration: InputDecoration(
              labelText: "playlist_name".tr(),
              errorText: logic.playlistError.value.isEmpty
                  ? null
                  : logic.playlistError.value,
            ),
          ),
        ),
      ],
    );
  }
}

class PlaylistSelectSongs extends StatelessWidget {
  final List<OneSong> songs;
  final List<OneSong> selectedSongs = [];

  PlaylistSelectSongs({super.key, required this.songs});

  final PlaylistLogic logic = Get.put(PlaylistLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            logic.playlistNameController.text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PlaylistSongTile(song: songs[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    logic.clearFields();
                    Get.back();
                  },
                  child: Text("cancel".tr()),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (logic.selectedSongs.isEmpty) {
                      AppToast.showToast(
                        "no_songs_selected",
                        "no_songs_selected_playlist",
                      );
                      return;
                    }
                    logic.savePlaylist();
                    Get.back();
                  },
                  child: Text("save".tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_playlist.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/playlist/playlist_add_dialog.dart';
import 'package:one_music/theme/theme_extensions.dart';

class PlaylistLogic extends GetxController {
  RxList<OnePlaylist> playlists = <OnePlaylist>[].obs;
  RxString playlistError = "".obs;
  TextEditingController playlistNameController = TextEditingController();
  RxList<OneSong> selectedSongs = <OneSong>[].obs;

  void _loadPlaylists() {
    playlists.value = List<OnePlaylist>.from(DbController.playlistsBox.values);
  }

  void addPlaylist() {
    Get.defaultDialog(
      barrierDismissible: false,
      contentPadding: EdgeInsets.all(8),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Get.context!.colorScheme.onSurface,
          ),
          onPressed: () {
            playlistNameController.clear();
            playlistError.value = "";
            Get.back();
          },
          child: Text("cancel".tr()),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Get.context!.colorScheme.primary),
          ),
          onPressed: () async {
            var check = checkPlaylistName();

            if (check) {
              List<OneSong> songs = List<OneSong>.from(
                DbController.songsBox.values,
              );
              Get.back();

              if (songs.isEmpty) {
                AppToast.showToast(
                  "playlist_created",
                  "playlist_created_no_songs",
                  style: "info",
                );
                return;
              }

              await Get.bottomSheet(
                PlaylistSelectSongs(songs: songs),
                enableDrag: true,
                isDismissible: false,
              );
            }
          },
          child: Text("create".tr()),
        ),
      ],
      title: "create_playlist".tr(),
      content: PlaylistAddDialog(),
    );
  }

  bool checkPlaylistName() {
    if (playlistNameController.text.isEmpty) {
      playlistError.value = "playlist_name_error".tr();
      return false;
    }
    if (playlists.map((e) => e.name).contains(playlistNameController.text)) {
      playlistError.value = "playlist_name_exists".tr();
      return false;
    } else {
      playlistError.value = "";
      return true;
    }
  }

  void toggleSongSelected(OneSong song) {
    var needToInsert = !selectedSongs
        .map((element) => element.file)
        .contains(song.file);
    if (needToInsert) {
      Get.log("adding sond: ${song.file}");
      selectedSongs.add(song);
    } else {
      Get.log("removing sond: ${song.file}");
      selectedSongs.removeWhere((element) => element.file == song.file);
    }
  }

  void clearFields() {
    playlistNameController.clear();
    selectedSongs.clear();
    playlistError.value = "";
  }

  void savePlaylist() {
    var playlist = OnePlaylist(
      id: DateTime.now().millisecondsSinceEpoch,
      name: playlistNameController.text,
      picture: selectedSongs.first.picture,
      songs: selectedSongs,
    );
    DbController.playlistsBox.put(playlistNameController.text, playlist);

    playlists.add(playlist);
    clearFields();
  }

  void deletePlaylist(String name) {
    DbController.playlistsBox.delete(name);
    playlists.removeWhere((element) => element.name == name);
    Get.back();
    AppToast.showToast(
      "playlist_deleted",
      "playlist_deleted_success",
      style: "success",
    );
  }

  @override
  void onInit() {
    super.onInit();

    _loadPlaylists();
  }
}

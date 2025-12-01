import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:one_music/models/one_playlist.dart';
import 'package:one_music/pages/songs/view.dart';

import '../../common/db_controller.dart';
import '../../models/one_song.dart';

class SearchLogic extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<OneSong> songs = RxList<OneSong>([]);
  RxList<OnePlaylist> playlist = RxList<OnePlaylist>([]);

  void search(String query, Type search) {
    if (query.isEmpty) {
      songs.value = [];
      playlist.value = [];
      return;
    }

    if (search == SongsPage) {
      var allSongs = List<OneSong>.from(DbController.songsBox.values);
      songs.value = allSongs
          .where(
            (element) =>
                element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.artist.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } else {
      var allPlaylists = List<OnePlaylist>.from(
        DbController.playlistsBox.values,
      );
      playlist.value = allPlaylists
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }
}

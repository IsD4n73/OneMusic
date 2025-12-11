import 'dart:convert';

import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_song.dart';

import '../../models/one_playlist.dart';

class PlayerLogic extends GetxController {
  RxList<String> favourites = <String>[].obs;

  void toggleFavSong(OneSong song) {
    var playlists = List<OnePlaylist>.from(DbController.playlistsBox.values);
    var playlist = playlists.firstWhere(
      (element) => element.name == "favourites_track",
    );

    var songs = playlist.songs
        .map((e) => OneSong.fromJson(jsonDecode(e)))
        .toList();

    var songsFiles = songs.map((e) => e.file).toList();
    var needToInsert = !songsFiles.contains(song.file);

    if (needToInsert) {
      songs.add(song);
    } else {
      songs.removeWhere((element) => element.file == song.file);
    }

    favourites.value = songs.map((e) => e.file).toList();

    playlist = OnePlaylist(
      id: playlist.id,
      name: playlist.name,
      picture: playlist.picture,
      songs: songs.map((e) => jsonEncode(e.toJson())).toList(),
    );

    DbController.playlistsBox.put(playlist.name, playlist);
  }

  @override
  void onInit() {
    super.onInit();
    var playlists = List<OnePlaylist>.from(DbController.playlistsBox.values);
    var playlist = playlists.firstWhere(
      (element) => element.name == "favourites_track",
    );

    favourites.value = playlist.songs
        .map((e) => OneSong.fromJson(jsonDecode(e)).file)
        .toList();
  }
}

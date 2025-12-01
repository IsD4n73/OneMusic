import 'dart:convert';

import 'package:get/get.dart';

import '../../models/one_song.dart';

class PlaylistDetailsLogic extends GetxController {
  final List<String> songsJson;
  RxList<OneSong> songs = RxList<OneSong>([]);

  @override
  void onInit() {
    super.onInit();

    songs.value = songsJson
        .map((e) => OneSong.fromJson(jsonDecode(e)))
        .toList();
  }

  PlaylistDetailsLogic(this.songsJson);
}

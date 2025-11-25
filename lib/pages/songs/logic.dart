import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:get/get.dart';
import 'package:one_music/common/converter.dart';
import 'package:one_music/common/db_controller.dart';

import '../../models/one_song.dart';

class SongsLogic extends GetxController {
  RxList<OneSong> songs = <OneSong>[].obs;
  Rx<OneSong?> playingSong = null.obs;

  @override
  void onInit() {
    super.onInit();
    var jsonMeta = DbController.songsBox.values.toList();
    var jsonPicture = DbController.picturesBox.values.first;

    Map<String, dynamic> pictureLit = jsonDecode(jsonPicture);
    var songList = jsonMeta.map((e) => Converter.fromJson(e)).toList();

    songs.value = songList
        .map(
          (song) => OneSong(
            song,
            Uint8List.fromList(List<int>.from(pictureLit[song.file.path])),
          ),
        )
        .toList();
  }
}

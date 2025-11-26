import 'package:get/get.dart';
import 'package:one_music/common/db_controller.dart';

import '../../models/one_song.dart';

class SongsLogic extends GetxController {
  RxList<OneSong> songs = <OneSong>[].obs;
  Rx<OneSong?> playingSong = null.obs;

  @override
  void onInit() {
    super.onInit();

    songs.value = List<OneSong>.from(DbController.songsBox.values);
  }
}

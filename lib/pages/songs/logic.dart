import 'dart:io';

import 'package:get/get.dart';
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/one_song.dart';

class SongsLogic extends GetxController {
  RxList<OneSong> songs = <OneSong>[].obs;
  Rx<OneSong?> playingSong = null.obs;

  void deleteSong(OneSong song) async {
    var status = await Permission.manageExternalStorage.request();
    Get.log(status.toString());

    if (status.isGranted) {
      songs.removeWhere((element) => element.file == song.file);
      DbController.songsBox.clear();
      DbController.songsBox.addAll(songs);

      try {
        File(song.file).delete();
        AppToast.showToast(
          "deleted_song",
          "deleted_song_success",
          style: "success",
        );
      } catch (e) {
        Get.log(e.toString());
        AppToast.showToast("deleted_song", "deleted_song_error");
      }
    } else {
      AppToast.showToast("deleted_song", "deleted_song_error");
    }

    Get.back();
  }

  @override
  void onInit() {
    super.onInit();

    songs.value = List<OneSong>.from(DbController.songsBox.values);
  }
}

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:get/get.dart';
import 'package:one_music/common/converter.dart';
import 'package:one_music/common/db_controller.dart';

class SongsLogic extends GetxController {
  RxList<AudioMetadata> songs = <AudioMetadata>[].obs;
  Rx<AudioMetadata?> playingSong = null.obs;

  @override
  void onInit() {
    super.onInit();
    var jsonMeta = DbController.songsBox.values.toList();
    songs.value = jsonMeta.map((e) => Converter.fromJson(e)).toList();
  }
}

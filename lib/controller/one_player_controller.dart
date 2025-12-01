import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_music/models/one_song.dart';

class OnePlayerController extends GetxController {
  final player = AudioPlayer();
  Rx<OneSong?> playingSong = Rx<OneSong?>(null);
  RxBool isPlaying = RxBool(false);

  Future<void> loadPlaylist(List<OneSong> songs, int index) async {
    Get.log("loadPlaylist");
    try {
      await player.clearAudioSources();
      Get.log("loadPlaylist, clearing");
      await player.setAudioSources(
        songs.map((e) => AudioSource.file(e.file)).toList(),
        initialIndex: index,
      );
      await player.play();
      Get.log("loadPlaylist, playing: ${player.playing}");
    } catch (e) {
      Get.log(e.toString());
    }
  }

  void nextSong() {
    player.seekToNext();
  }

  void previousSong() {
    player.seekToPrevious();
  }

  void togglePlaySong() async {
    Get.log("togglePlaySong, playing: ${player.playing}");
    isPlaying.value = !player.playing;
    player.playing ? player.pause() : player.play();
  }

  @override
  void onInit() {
    super.onInit();

    player.playerStateStream.listen((event) {
      Get.log("playerStateStream, playing: ${event.playing}");
      isPlaying.value = event.playing;
    });
  }
}

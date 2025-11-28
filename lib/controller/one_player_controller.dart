import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_music/models/one_song.dart';

class OnePlayerController extends GetxController {
  final player = AudioPlayer();
  Rx<OneSong?> playingSong = Rx<OneSong?>(null);

  void playSong(String path) {}

  void loadPlaylist(List<OneSong> songs) {}

  void nextSong() {}

  void previousSong() {}

  void togglePlaySong() {
    player.playing ? player.pause() : player.play();
  }
}

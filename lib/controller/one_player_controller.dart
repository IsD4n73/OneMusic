import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
        songs
            .map(
              (e) => AudioSource.file(
                e.file,
                tag: MediaItem(
                  id: e.file,
                  title: e.title,
                  album: e.album,
                  artist: e.artist,
                  duration: e.duration,
                  extras: {"onesong": e},
                ),
              ),
            )
            .toList(),
        initialIndex: index,
      );
      await player.play();
      Get.log("loadPlaylist, playing: ${player.playing}");
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Future<List<OneSong>> nextSong(List<OneSong> songs) async {
    await player.seekToNext();

    var source =
        player.audioSources[player.currentIndex ?? 0] as ProgressiveAudioSource;
    var mediaItem = source.tag as MediaItem;
    var song = mediaItem.extras?["onesong"] as OneSong;

    playingSong.value = song;

    Get.log("now playing: ${song.file}");
    return _refreshSongs(songs);
  }

  Future<List<OneSong>> previousSong(List<OneSong> songs) async {
    await player.seekToPrevious();

    var source =
        player.audioSources[player.currentIndex ?? 0] as ProgressiveAudioSource;
    var mediaItem = source.tag as MediaItem;
    var song = mediaItem.extras?["onesong"] as OneSong;

    playingSong.value = song;

    Get.log("now playing: ${playingSong.value?.file}");
    return _refreshSongs(songs);
  }

  void togglePlaySong() async {
    Get.log("togglePlaySong, playing: ${player.playing}");
    isPlaying.value = !player.playing;
    player.playing ? player.pause() : player.play();
  }

  List<OneSong> getPlayerSource() {
    return player.audioSources.map((e) {
      var source = player.audioSource as ProgressiveAudioSource;
      var mediaItem = source.tag as MediaItem;
      var song = mediaItem.extras?["onesong"] as OneSong;

      return song;
    }).toList();
  }

  List<OneSong> _refreshSongs(List<OneSong> songs) {
    List<OneSong> tmpSongs = [];

    for (var element in songs) {
      tmpSongs.add(element.copyWith(selected: false));
    }

    var index = tmpSongs.indexWhere(
      (element) => playingSong.value?.file == element.file,
    );
    tmpSongs[index] = tmpSongs[index].copyWith(selected: true);

    return tmpSongs;
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

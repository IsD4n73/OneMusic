import 'dart:io';

import 'package:discord_rich_presence/discord_rich_presence.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_song.dart';

class OnePlayerController extends GetxController {
  final player = AudioPlayer();
  final Client richClient = Client(
    clientId: dotenv.env['RICH_CLIENT'] ?? "NULL",
  );
  Rx<OneSong?> playingSong = Rx<OneSong?>(null);
  RxBool isPlaying = RxBool(false);

  Future<void> loadPlaylist(List<OneSong> songs, int index) async {
    Get.log("loadPlaylist");
    try {
      await player.clearAudioSources();
      Get.log("loadPlaylist, clearing");

      await player.setAudioSources(
        songs.map((e) {
          var media = MediaItem(
            id: e.hashCode.toString(),
            title: e.title,
            album: e.album,
            artUri: e.picture != null && e.file.startsWith("http")
                ? Uri.parse(e.picture!)
                : Uri.parse(
                    "https://raw.githubusercontent.com/IsD4n73/OneMusic/refs/heads/main/assets/images/icon.png",
                  ),
            artist: e.artist,
            duration: e.duration,
            displayTitle: e.title,
            displaySubtitle: e.artist,
            extras: {"onesong": e.toJson()},
          );
          return e.file.startsWith("http")
              ? AudioSource.uri(Uri.parse(e.file), tag: media)
              : AudioSource.file(e.file, tag: media);
        }).toList(),
        initialIndex: index,
      );

      _setRichPresence(songs[index]);

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
    var songjson = mediaItem.extras?["onesong"] as Map<String, dynamic>;
    var song = OneSong.fromJson(songjson);

    _setRichPresence(song);

    playingSong.value = song;

    Get.log("now playing: ${song.file}");
    return _refreshSongs(songs);
  }

  Future<List<OneSong>> previousSong(List<OneSong> songs) async {
    await player.seekToPrevious();

    var source =
        player.audioSources[player.currentIndex ?? 0] as ProgressiveAudioSource;
    var mediaItem = source.tag as MediaItem;
    var songjson = mediaItem.extras?["onesong"] as Map<String, dynamic>;
    var song = OneSong.fromJson(songjson);

    _setRichPresence(song);

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
      var songjson = mediaItem.extras?["onesong"] as Map<String, dynamic>;
      var song = OneSong.fromJson(songjson);

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

  void _setRichPresence(OneSong song) {
    if (Platform.isWindows) {
      if (!DbController.generalBox.get(
        "showRichPresence",
        defaultValue: false,
      )) {
        return;
      }
      Get.log("setRichPresence for ${song.title}");
      richClient.setActivity(
        Activity(
          name: song.title,
          details: song.artist,
          type: ActivityType.listening,
          timestamps: ActivityTimestamps(
            start: DateTime.now(),
            end: DateTime.now().add(song.duration),
          ),
        ),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (Platform.isWindows &&
        DbController.generalBox.get("showRichPresence", defaultValue: false)) {
      richClient.connect();
    }

    player.playbackEventStream.listen((event) {
      var currentIndex = event.currentIndex ?? 0;

      if (player.audioSources.isEmpty) return;

      var source = player.audioSources[currentIndex] as ProgressiveAudioSource;
      var mediaItem = source.tag as MediaItem;
      var songjson = mediaItem.extras?["onesong"] as Map<String, dynamic>;
      var song = OneSong.fromJson(songjson);

      playingSong.value = song;

      Get.log("now playing: ${playingSong.value?.file}");
    });

    player.playerStateStream.listen((event) {
      Get.log("playerStateStream, playing: ${event.playing}");
      isPlaying.value = event.playing;
    });
  }
}

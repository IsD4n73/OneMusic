import 'dart:async';

import 'package:get/get.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_song.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtPlayerController extends GetxController {
  final yt = YoutubeExplode();

  Timer? _debounce;

  RxList<OneSong> searchResults = RxList<OneSong>([]);

  void search(String query, bool searchPlaylist) {
    if (!DbController.generalBox.get('searchOnline', defaultValue: false)) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      searchResults.clear();
      Get.log("searching online");
      var results = (await yt.search.search(query)).take(5);
      Get.log("results: ${results.length}");
      for (var vid in results) {
        var manifest = await yt.videos.streamsClient.getManifest(vid.id);

        var streamInfo = manifest.audio.withHighestBitrate();
        var url = streamInfo.url.toString();

        var song = OneSong(
          selected: false,
          album: "yt",
          year: vid.uploadDate?.year ?? 0,
          artist: vid.author,
          title: vid.title,
          trackNumber: 0,
          trackTotal: 0,
          duration: vid.duration ?? Duration.zero,
          genres: [],
          lyrics: "",
          discNumber: 0,
          totalDisc: 0,
          file: url,
          picture: vid.thumbnails.standardResUrl,
        );
        searchResults.add(song);
      }
    });
  }
}

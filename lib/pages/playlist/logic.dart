import 'package:get/get.dart';
import 'package:one_music/models/one_playlist.dart';

class PlaylistLogic extends GetxController {
  RxList<OnePlaylist> playlists = <OnePlaylist>[].obs;

  void _loadPlaylists() {}

  @override
  void onInit() {
    super.onInit();

    _loadPlaylists();
  }
}

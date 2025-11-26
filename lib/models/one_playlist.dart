import 'package:one_music/models/one_song.dart';

class OnePlaylist {
  final int id;
  final String name;
  final String? picture;
  final List<OneSong> songs;

  OnePlaylist({
    required this.id,
    required this.name,
    required this.picture,
    required this.songs,
  });
}

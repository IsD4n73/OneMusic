import 'dart:convert';
import 'dart:typed_data';

import 'package:one_music/models/one_song.dart';

class OnePlaylist {
  final int id;
  final String name;
  final Uint8List? picture;
  final List<OneSong> songs;

  OnePlaylist(this.id, this.name, this.picture, this.songs);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "picture": base64Encode(picture ?? []),
      "songs": songs.map((e) => e.toJson()).toList(),
    };
  }

  factory OnePlaylist.fromJson(Map<String, dynamic> json) {
    return OnePlaylist(
      json["id"],
      json["name"],
      base64Decode(json["picture"]),
      List<OneSong>.from(json["songs"].map((e) => OneSong.fromJson(e))),
    );
  }
}

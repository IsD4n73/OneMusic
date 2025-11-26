import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:one_music/common/converter.dart';

class OneSong {
  final AudioMetadata data;
  final Uint8List? picture;

  OneSong(this.data, this.picture);

  Map<String, dynamic> toJson() {
    return {
      "data": Converter.toJson(data),
      "picture": base64Encode(picture ?? []),
    };
  }

  factory OneSong.fromJson(Map<String, dynamic> json) {
    return OneSong(
      Converter.fromJson(json["data"]),
      base64Decode(json["picture"]),
    );
  }
}

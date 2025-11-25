import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class OneSong {
  final AudioMetadata data;
  final Uint8List? picture;

  OneSong(this.data, this.picture);
}

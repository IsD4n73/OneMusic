import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  final AudioMetadata song;
  final void Function() onTap;
  final bool isPlaying;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:one_music/common/formatter.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/theme/theme_extensions.dart';

class SongTile extends StatelessWidget {
  final OneSong song;
  final void Function() onTap;
  final void Function(Offset position) onLongTap;
  final bool isPlaying;
  final bool isSelected;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.isPlaying,
    required this.isSelected,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (details) => onLongTap(details.globalPosition),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              song.picture != null
                  ? Image.memory(
                      base64Decode(song.picture!),
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/images/icon.png",
                        width: 50,
                        height: 50,
                      ),
                    )
                  : Image.asset(
                      "assets/images/icon.png",
                      width: 50,
                      height: 50,
                    ),
              SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(song.artist, style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Spacer(),
              isSelected
                  ? MiniMusicVisualizer(
                      color: context.colorScheme.primary,
                      width: 3,
                      animate: isPlaying,
                      height: 15,
                    )
                  : SizedBox.shrink(),
              SizedBox(width: 5),
              Text(
                Formatter.formatDuration(song.duration),
                style: TextStyle(
                  fontSize: 10,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

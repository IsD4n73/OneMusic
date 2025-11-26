import 'dart:convert';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/theme/theme_extensions.dart';

class PlayerWidget extends StatelessWidget {
  final void Function()? onLeft;
  final void Function()? onPlay;
  final void Function()? onRight;
  final void Function()? onTapCard;
  final OneSong song;
  const PlayerWidget({
    super.key,
    this.onLeft,
    this.onPlay,
    this.onRight,
    required this.song,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: InkWell(
        onTap: onTapCard,
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.colorScheme.onSecondary,
          ),
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
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title),
                  Text(song.artist, style: TextStyle(fontSize: 13)),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: onLeft,
                child: Icon(Icons.keyboard_double_arrow_left, size: 30),
              ),
              InkWell(onTap: onPlay, child: Icon(Icons.play_arrow, size: 30)),
              InkWell(
                onTap: onRight,
                child: Icon(Icons.keyboard_double_arrow_right, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

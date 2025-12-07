import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/widgets/one_image.dart';
import 'package:one_music/theme/theme_extensions.dart';

class PlayerWidget extends StatelessWidget {
  final void Function()? onLeft;
  final void Function()? onPlay;
  final void Function()? onRight;
  final void Function()? onTapCard;
  final OneSong song;
  final bool isPlaying;
  const PlayerWidget({
    super.key,
    this.onLeft,
    this.onPlay,
    this.onRight,
    required this.song,
    this.onTapCard,
    required this.isPlaying,
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
              OneImage(picture: song.picture, size: OneImageSize.medium),
              SizedBox(width: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title, overflow: TextOverflow.ellipsis),
                    Text(
                      song.artist,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: onLeft,
                child: Icon(Icons.skip_previous, size: 30),
              ),
              InkWell(
                onTap: onPlay,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                ),
              ),
              InkWell(onTap: onRight, child: Icon(Icons.skip_next, size: 30)),
            ],
          ),
        ),
      ),
    );
  }
}

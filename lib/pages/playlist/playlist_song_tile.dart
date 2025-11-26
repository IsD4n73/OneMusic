import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_music/models/one_song.dart';

import 'logic.dart';

class PlaylistSongTile extends StatelessWidget {
  final OneSong song;
  PlaylistSongTile({super.key, required this.song});

  final PlaylistLogic logic = Get.put(PlaylistLogic());

  @override
  Widget build(BuildContext context) {
    return Card(
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
                : Image.asset("assets/images/icon.png", width: 50, height: 50),
            SizedBox(width: 5),
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
            Obx(
              () => Checkbox(
                value: logic.selectedSongs
                    .map((element) => element.file)
                    .contains(song.file),
                onChanged: (_) {
                  logic.toggleSongSelected(song);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

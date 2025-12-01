import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:one_music/models/one_playlist.dart';

class PlaylistTile extends StatelessWidget {
  final OnePlaylist playlist;
  final void Function() onTap;

  const PlaylistTile({super.key, required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              playlist.picture != null
                  ? Image.memory(
                      base64Decode(playlist.picture!),
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
                      playlist.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${playlist.songs.length} ${"track".tr()}",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

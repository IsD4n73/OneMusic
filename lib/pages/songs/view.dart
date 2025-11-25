import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/widgets/player_widget.dart';
import 'package:one_music/pages/widgets/one_app_bar.dart';
import 'package:one_music/pages/widgets/song_tile.dart';

import 'logic.dart';

class SongsPage extends StatelessWidget {
  SongsPage({super.key});

  final SongsLogic logic = Get.put(SongsLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneAppBar(
          textOne: "your".tr(),
          textTwo: "songs".tr(),
          rightIcon: Icons.search,
          onTap: () {},
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: logic.songs.length,
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SongTile(
                              song: logic.songs[index],
                              isSelected:
                                  logic.songs[index].data.file.path ==
                                  logic.playingSong.value?.data.file.path,
                              onTap: () {},
                              isPlaying: false,
                            ),
                            index == (logic.songs.length - 1) &&
                                    logic.playingSong.value != null
                                ? SizedBox(height: 70)
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Obx(
                () => logic.playingSong.value != null
                    ? PlayerWidget(
                        song: logic.playingSong.value!,
                        onLeft: () {},
                        onPlay: () {},
                        onRight: () {},
                        onTapCard: () {},
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

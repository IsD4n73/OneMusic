import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/widgets/one_error_widget.dart';

import '../widgets/one_app_bar.dart';
import 'logic.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({super.key});

  final PlaylistLogic logic = Get.put(PlaylistLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneAppBar(
          textOne: "your".tr(),
          textTwo: "playlists".tr(),
          rightIcon: Icons.search,
          onTap: () {},
        ),
        SizedBox(height: 10),
        Card(
          margin: EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.playlist_add),
                  SizedBox(width: 10),
                  Text("create_playlist".tr()),
                ],
              ),
            ),
          ),
        ),
        Divider(),
        Obx(
          () => logic.playlists.isEmpty
              ? OneErrorWidget(error: "no_playlists_found")
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/models/one_song.dart';
import 'package:one_music/theme/theme_extensions.dart';

import 'logic.dart';

class SongEditSheet extends StatelessWidget {
  final OneSong song;
  SongEditSheet({super.key, required this.song});

  final SongsLogic logic = Get.put(SongsLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            song.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Obx(
            () => Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: logic.titleController,
                      onChanged: (value) => logic.checkFields(),
                      decoration: InputDecoration(
                        labelText: "title".tr(),
                        errorText: logic.titleError.value.isEmpty
                            ? null
                            : logic.titleError.value,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: logic.artistController,

                      onChanged: (value) => logic.checkFields(),
                      decoration: InputDecoration(
                        labelText: "artist".tr(),
                        errorText: logic.artistError.value.isEmpty
                            ? null
                            : logic.artistError.value,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: logic.albumController,
                      onChanged: (value) => logic.checkFields(),
                      decoration: InputDecoration(labelText: "album".tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("cancel".tr()),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    var check = logic.checkFields();

                    if (!check) {
                      logic.saveSongMeta(song.file);
                    }
                  },
                  child: Text("save".tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

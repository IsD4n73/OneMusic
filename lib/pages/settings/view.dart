import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/settings/settings_card.dart';
import 'package:one_music/pages/settings/settings_tile.dart';

import '../widgets/one_app_bar.dart';
import 'logic.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final SettingsLogic logic = Get.put(SettingsLogic());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OneAppBar(),
            SettingsTile(
              title: "ui_settings",
              subtitle: "ui_settings_subtitle",
            ),
            SettingsTile(
              title: "language_settings",
              subtitle: "language_settings_subtitle",
            ),
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: [
                SettingsCard(
                  icon: Icon(Icons.abc),
                  text: "Italiano",
                  selected: context.locale.languageCode == "it",
                  onTap: () {
                    context.setLocale(Locale("it"));
                  },
                ),
                SettingsCard(
                  icon: Icon(Icons.abc),
                  text: "English",
                  selected: context.locale.languageCode == "en",
                  onTap: () {
                    context.setLocale(Locale("en"));
                  },
                ),
              ],
            ),
            SettingsTile(
              title: "information_settings",
              subtitle: "information_settings_subtitle",
            ),
          ],
        ),
      ),
    );
  }
}

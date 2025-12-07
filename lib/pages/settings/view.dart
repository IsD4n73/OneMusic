import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/pages/settings/settings_card.dart';
import 'package:one_music/pages/settings/settings_tile.dart';

import '../widgets/one_app_bar.dart';
import 'logic.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

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
              title: "language_settings",
              subtitle: "language_settings_subtitle",
            ),
            GridView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              children: [
                SettingsCard(
                  icon: Text("🇮🇹", style: TextStyle(fontSize: 40)),
                  text: "Italiano",
                  selected: context.locale.languageCode == "it",
                  onTap: () {
                    context.setLocale(Locale("it"));
                    AppToast.showToast(
                      "restart_app",
                      "languace_changed_info",
                      style: "info",
                    );
                  },
                ),
                SettingsCard(
                  icon: Text("🇺🇸", style: TextStyle(fontSize: 40)),
                  text: "English",
                  selected: context.locale.languageCode == "en",
                  onTap: () {
                    context.setLocale(Locale("en"));
                    AppToast.showToast(
                      "restart_app",
                      "languace_changed_info",
                      style: "info",
                    );
                  },
                ),
              ],
            ),
            SettingsTile(
              title: "general_settings",
              subtitle: "general_settings_subtitle",
            ),
            SizedBox(height: 20),
            Obx(
              () => SwitchListTile(
                value: logic.searchOnline.value,
                onChanged: (value) {
                  logic.changeSearchOnlineSetting(value);
                },
                title: Text("search_online_settings".tr()),
                subtitle: Text("search_online_settings_subtitle".tr()),
              ),
            ),
            Divider(),
            Platform.isAndroid
                ? Obx(
                    () => SwitchListTile(
                      value: logic.backgroundPermission.value,
                      onChanged: (value) {
                        if (!value) {
                          AppToast.showToast(
                            "permission_already_granted",
                            "permission_already_granted_desc",
                            style: "info",
                          );
                          return;
                        }

                        logic.backgroundPermissionChange();
                      },
                      title: Text("background_permission_settings".tr()),
                      subtitle: Text(
                        "background_permission_settings_subtitle".tr(),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Platform.isAndroid
                ? Obx(
                    () => SwitchListTile(
                      value: logic.storagePermission.value,
                      onChanged: (value) {
                        if (!value) {
                          AppToast.showToast(
                            "permission_already_granted",
                            "permission_already_granted_desc",
                            style: "info",
                          );
                          return;
                        }
                        logic.storagePermissionChange();
                      },
                      title: Text("storage_permission_settings".tr()),
                      subtitle: Text(
                        "storage_permission_settings_subtitle".tr(),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Platform.isAndroid ? Divider() : SizedBox.shrink(),
            Obx(
              () => SwitchListTile(
                value: logic.getNoSong.value,
                onChanged: (value) {
                  logic.changeNoSongSetting(value);
                },
                title: Text("get_no_song_settings".tr()),
                subtitle: Text("get_no_song_settings_subtitle".tr()),
              ),
            ),
            Platform.isWindows ? Divider() : SizedBox.shrink(),
            Platform.isWindows
                ? Obx(
                    () => SwitchListTile(
                      value: logic.richPresence.value,
                      onChanged: (value) {
                        logic.changeRichSetting(value);
                      },
                      title: Text("rich_presence_settings".tr()),
                      subtitle: Text("rich_presence_settings_subtitle".tr()),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

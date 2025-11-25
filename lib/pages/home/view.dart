import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/settings/view.dart';
import 'package:one_music/pages/songs/view.dart';
import 'package:one_music/theme/theme_extensions.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../playlist/view.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: context.colorScheme.surface,

      tabs: [
        PersistentTabConfig(
          screen: SongsPage(),
          item: ItemConfig(
            activeColorSecondary: context.colorScheme.primary,
            activeForegroundColor: context.colorScheme.onSurface,
            inactiveForegroundColor: context.colorScheme.onSurface,
            icon: Icon(Icons.music_note),
            title: "songs_title".tr(),
          ),
        ),
        PersistentTabConfig(
          screen: PlaylistPage(),
          item: ItemConfig(
            activeColorSecondary: context.colorScheme.primary,
            activeForegroundColor: context.colorScheme.onSurface,
            inactiveForegroundColor: context.colorScheme.onSurface,
            icon: Icon(Icons.playlist_add_check),
            title: "playlist_title".tr(),
          ),
        ),
        PersistentTabConfig(
          screen: SettingsPage(),
          item: ItemConfig(
            activeColorSecondary: context.colorScheme.primary,
            activeForegroundColor: context.colorScheme.onSurface,
            inactiveForegroundColor: context.colorScheme.onSurface,
            icon: Icon(Icons.settings),
            title: "settings_title".tr(),
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(color: context.colorScheme.surface),
      ),
    );
  }
}

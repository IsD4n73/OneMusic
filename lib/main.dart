import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/hive/hive_adapters.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'it.d4n73.onemusic.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();

  Hive.registerAdapter(OneSongAdapter());
  Hive.registerAdapter(OnePlaylistAdapter());

  DbController.songsBox = await Hive.openBox('songs');
  DbController.playlistsBox = await Hive.openBox('playlist');
  DbController.generalBox = await Hive.openBox('general');

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

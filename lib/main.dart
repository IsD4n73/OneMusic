import 'package:audio_metadata_reader/audio_metadata_reader.dart'
    show AudioMetadata;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:one_music/common/db_controller.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  DbController.songsBox = await Hive.openBox('songs');
  DbController.playlistsBox = await Hive.openBox('playlist');
  DbController.picturesBox = await Hive.openBox('pictures');

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

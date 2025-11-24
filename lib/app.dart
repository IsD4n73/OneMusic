import 'package:flutter/material.dart';
import 'package:one_music/pages/splash/view.dart';
import 'package:one_music/theme/app_theme.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'One Music',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashPage(),
    );
  }
}

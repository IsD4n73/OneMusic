import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:one_music/pages/splash/view.dart';
import 'package:one_music/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'One Music',
        navigatorKey: Get.key,
        navigatorObservers: [GetObserver()],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: SplashPage(),
      ),
    );
  }
}

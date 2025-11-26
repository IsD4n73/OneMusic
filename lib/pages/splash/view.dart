import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:one_music/theme/theme_extensions.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashLogic logic = Get.put(SplashLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icon.png",
                color: context.colorScheme.onSecondary,
              ),
              SizedBox(height: 20),
              Text("file_loading_device".tr()),
              SizedBox(height: 20),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

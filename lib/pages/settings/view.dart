import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/one_app_bar.dart';
import 'logic.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final SettingsLogic logic = Get.put(SettingsLogic());

  @override
  Widget build(BuildContext context) {
    return Column(children: [OneAppBar()]);
  }
}

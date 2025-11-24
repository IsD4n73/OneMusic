import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final SplashLogic logic = Get.put(SplashLogic());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

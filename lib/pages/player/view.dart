import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key? key}) : super(key: key);

  final PlayerLogic logic = Get.put(PlayerLogic());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

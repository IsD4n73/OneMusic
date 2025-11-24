import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({Key? key}) : super(key: key);

  final PlaylistLogic logic = Get.put(PlaylistLogic());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

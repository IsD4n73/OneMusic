import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/pages/widgets/one_app_bar.dart';

import 'logic.dart';

class SongsPage extends StatelessWidget {
  SongsPage({super.key});

  final SongsLogic logic = Get.put(SongsLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneAppBar(
          textOne: "your".tr(),
          textTwo: "songs".tr(),
          rightIcon: Icons.search,
          onTap: () {},
        ),
      ],
    );
  }
}

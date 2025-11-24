import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final SplashLogic logic = Get.put(SplashLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: logic.getAudioFiles(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Caricamento file dal dispositivo in corso..."),
                  SizedBox(height: 20),
                  LinearProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

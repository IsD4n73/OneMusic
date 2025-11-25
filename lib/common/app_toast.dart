import 'package:toastification/toastification.dart';
import 'package:get/get.dart' hide Trans;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppToast {
  static void showErrorToast(String title, String text) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(title.tr()),
      description: Text(text.tr()),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: highModeShadow,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      applyBlurEffect: false,
    );
  }
}

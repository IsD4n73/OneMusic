import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsLogic extends GetxController with WidgetsBindingObserver {
  RxBool backgroundPermission = true.obs;
  RxBool storagePermission = true.obs;

  void getPermissions() async {
    bool? isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    backgroundPermission.value = isBatteryOptimizationDisabled ?? true;

    var manageStatus = await Permission.manageExternalStorage.isGranted;
    storagePermission.value = manageStatus;
  }

  void backgroundPermissionChange() async {
    var opt =
        await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    Get.log("Battery Optimization: $opt");

    getPermissions();
  }

  void storagePermissionChange() async {
    var manageStatus = await Permission.manageExternalStorage.request();
    storagePermission.value = manageStatus.isGranted;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getPermissions();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getPermissions();
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/one_song.dart';

class SongsLogic extends GetxController {
  RxList<OneSong> songs = <OneSong>[].obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  Rx<Uint8List> image = Uint8List(0).obs;
  RxString titleError = "".obs;
  RxString artistError = "".obs;

  void prefillFields(OneSong song) {
    clearFields();
    titleController.text = song.title;
    artistController.text = song.artist;
    albumController.text = song.album;
  }

  void clearFields() {
    titleController.clear();
    artistController.clear();
    albumController.clear();
    titleError.value = "";
    artistError.value = "";
    image.value = Uint8List(0);
  }

  bool checkFields() {
    var check = false;
    if (titleController.text.isEmpty) {
      titleError.value = "update_title_error".tr();
      check = true;
    }

    if (artistController.text.isEmpty) {
      artistError.value = "update_artist_error".tr();
      check = true;
    }

    return check;
  }

  void saveSongMeta(String path) async {
    var file = File(path);

    updateMetadata(file, (metadata) {
      metadata.setAlbum(albumController.text);
      metadata.setArtist(artistController.text);
      metadata.setTitle(titleController.text);
      if (image.value.isNotEmpty) {
        metadata.setPictures([
          Picture(image.value, "image/png", PictureType.coverFront),
        ]);
      }
    });

    songs.removeWhere((element) => element.file == path);
    try {
      var meta = readMetadata(file, getImage: true);

      var oneSong = OneSong(
        album: meta.album ?? "",
        year: meta.year?.year ?? 0,
        artist: meta.artist ?? "",
        title: meta.title ?? "",
        selected: false,
        trackNumber: meta.trackNumber ?? 0,
        trackTotal: meta.trackTotal ?? 0,
        duration: meta.duration ?? Duration.zero,
        genres: meta.genres,
        discNumber: meta.discNumber ?? 0,
        totalDisc: meta.totalDisc ?? 0,
        lyrics: meta.lyrics ?? "",
        file: meta.file.path,
        picture: base64Encode(meta.pictures.first.bytes),
      );
      songs.add(oneSong);
    } catch (e) {
      Get.log('Error reading metadata: $e');
    }
    await DbController.songsBox.clear();
    await DbController.songsBox.addAll(songs);
    await DbController.songsBox.flush();
    songs.clear();
    songs.addAll(List<OneSong>.from(DbController.songsBox.values));

    clearFields();
    Get.back();
  }

  void deleteSong(OneSong song) async {
    var status = await Permission.manageExternalStorage.request();
    Get.log(status.toString());

    if (status.isGranted) {
      songs.removeWhere((element) => element.file == song.file);
      DbController.songsBox.clear();
      DbController.songsBox.addAll(songs);

      try {
        File(song.file).delete();
        AppToast.showToast(
          "deleted_song",
          "deleted_song_success",
          style: "success",
        );
      } catch (e) {
        Get.log(e.toString());
        AppToast.showToast("deleted_song", "deleted_song_error");
      }
    } else {
      AppToast.showToast("deleted_song", "deleted_song_error");
    }

    Get.back();
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      compressionQuality: 50,
      withReadStream: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.bytes == null) {
      AppToast.showToast("image_error", "image_error_desc", style: "info");
      return;
    }

    image.value = result.files.first.bytes ?? Uint8List(0);
  }

  @override
  void onInit() {
    super.onInit();

    songs.value = List<OneSong>.from(DbController.songsBox.values);

    Future.delayed(Duration.zero, () async {
      bool? isBatteryOptimizationDisabled =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      if (!(isBatteryOptimizationDisabled ?? true)) {
        var opt =
            await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
        Get.log("Battery Optimization: $opt");
      }
    });
  }
}

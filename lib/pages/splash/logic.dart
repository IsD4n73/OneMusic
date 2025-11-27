import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/home/view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:win32/win32.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class SplashLogic extends GetxController {
  var audioExtensions = ['.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a'];

  Future<Directory?> _getMusicDirectory() async {
    // ANDROID
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      var permissionGranted = false;
      if (androidInfo.version.sdkInt < 22) {
        var status = await Permission.storage.request();
        permissionGranted = status.isGranted;
      } else {
        // Android 13+ (audio)
        var status = await Permission.audio.request();
        permissionGranted = status.isGranted;
      }

      if (!permissionGranted) {
        AppToast.showToast("permission_denied", "permission_denied_desc");
        return null;
      }

      return Directory('/storage/emulated/0/Music');
    }

    // WINDOWS
    if (Platform.isWindows) {
      final pathPtr = wsalloc(MAX_PATH);

      final hr = SHGetFolderPath(NULL, CSIDL_MYMUSIC, NULL, NULL, pathPtr);

      if (FAILED(hr)) {
        free(pathPtr);
        throw WindowsException(hr);
      }

      final path = pathPtr.toDartString();
      free(pathPtr);

      return Directory(path);
    }

    // fallback
    return await getApplicationDocumentsDirectory();
  }

  Future<List<OneSong>> getAudioFiles() async {
    var dir = await _getMusicDirectory();
    if (dir == null) return [];

    Get.log('Music Dir: ${dir.path}');

    if (!await dir.exists()) return [];

    final List<OneSong> audioFiles = [];
    var cleaned = await DbController.songsBox.clear();
    Get.log('Songs Cleaned: $cleaned');

    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final ext = entity.path.toLowerCase();

        if (audioExtensions.any((e) => ext.endsWith(e))) {
          try {
            var meta = readMetadata(entity, getImage: true);

            var oneSong = OneSong(
              album: meta.album ?? "",
              year: meta.year?.year ?? 0,
              artist: meta.artist ?? "",
              title: meta.title ?? "",
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

            audioFiles.add(oneSong);
          } catch (e) {
            Get.log('Error reading metadata: $e');
          }
        }
      }
    }

    await DbController.songsBox.addAll(audioFiles);
    Get.log('Audio Files Found: ${audioFiles.length}');
    Get.off(() => HomePage());
    return audioFiles;
  }

  @override
  void onInit() {
    super.onInit();
    getAudioFiles();
  }
}

import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class SplashLogic extends GetxController {
  var audioExtensions = ['.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a'];

  Future<Directory> _getMusicDirectory() async {
    if (Platform.isAndroid) {
      // ANDROID
      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.music,
      );
      if (dirs != null && dirs.isNotEmpty) return dirs.first;

      return await getApplicationDocumentsDirectory();
    }

    if (Platform.isWindows) {
      // WINDOWS
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

    // fallback per altre piattaforme
    return await getApplicationDocumentsDirectory();
  }

  Future<List<File>> getAudioFiles() async {
    var dir = await _getMusicDirectory();

    if (!await dir.exists()) return [];

    final List<File> audioFiles = [];

    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final ext = entity.path.toLowerCase();

        if (audioExtensions.any((e) => ext.endsWith(e))) {
          audioFiles.add(entity);
        }
      }
    }

    return audioFiles;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:one_music/common/app_toast.dart';
import 'package:one_music/common/db_controller.dart';
import 'package:one_music/models/one_song.dart';
import 'package:one_music/pages/home/view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:win32/win32.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import '../../models/one_playlist.dart';

class SplashLogic extends GetxController {
  var audioExtensions = ['.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a'];

  Future<Directory?> _getMusicDirectory() async {
    // ANDROID
    if (Platform.isAndroid) {
      bool? isBatteryOptimizationDisabled =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      if (!(isBatteryOptimizationDisabled ?? true)) {
        var opt =
            await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
        Get.log("Battery Optimization: $opt");
      }

      var manageStatus = await Permission.manageExternalStorage.request();
      if (!manageStatus.isGranted) {
        AppToast.showToast(
          "permission_denied",
          "permission_denied_manage_desc",
        );
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

    var noSong = DbController.generalBox.get('getNoSong') ?? false;

    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final ext = entity.path.toLowerCase();

        if (audioExtensions.any((e) => ext.endsWith(e))) {
          try {
            var meta = readMetadata(entity, getImage: true);

            var oneSong = OneSong(
              onlineId: "",
              album: meta.album ?? "",
              selected: false,
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
            Get.log('| try second method | Error reading metadata: $e ');

            try {
              final fileMetadata = await AudioTags.read(entity.path);

              var oneSong = OneSong(
                onlineId: "",
                album: fileMetadata?.album ?? "",
                selected: false,
                year: fileMetadata?.year ?? 0,
                artist: fileMetadata?.trackArtist ?? "",
                title: fileMetadata?.title ?? "",
                trackNumber: fileMetadata?.trackNumber ?? 0,
                trackTotal: 0,
                duration: Duration(milliseconds: fileMetadata?.duration ?? 0),
                genres: [fileMetadata?.genre ?? ""],
                discNumber: fileMetadata?.discNumber ?? 0,
                totalDisc: 0,
                lyrics: "",
                file: entity.path,
                picture: base64Encode(fileMetadata?.pictures.first.bytes ?? []),
              );

              audioFiles.add(oneSong);
            } catch (e) {
              Get.log('Error reading metadata: $e');
              if (noSong) {
                var oneSong = OneSong(
                  onlineId: "",
                  album: "",
                  year: 0,
                  artist: "",
                  selected: false,
                  title: entity.path.split('/').last,
                  trackNumber: 0,
                  trackTotal: 0,
                  duration: Duration.zero,
                  genres: [],
                  discNumber: 0,
                  totalDisc: 0,
                  lyrics: "",
                  file: entity.path,
                  picture: "",
                );
                audioFiles.add(oneSong);
              }
            }
          }
        }
      }
    }

    await DbController.songsBox.addAll(audioFiles);
    Get.log('Audio Files Found: ${audioFiles.length}');
    Get.off(() => HomePage());
    return audioFiles;
  }

  void _createNecessaryPlaylists() {
    var needToCreate = ["favourites_track".tr()];

    List<OnePlaylist> playlists = List<OnePlaylist>.from(
      DbController.playlistsBox.values,
    );
    var names = playlists.map((e) => e.name);

    for (var name in needToCreate) {
      var created = names.contains(name);
      if (!created) {
        DbController.playlistsBox.put(
          name,
          OnePlaylist(
            id: DateTime.now().millisecondsSinceEpoch,
            name: name,
            picture: null,
            songs: [],
          ),
        );
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      getAudioFiles();
      _createNecessaryPlaylists();
    });
  }
}

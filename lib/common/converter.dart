import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class Converter {
  static Map<String, dynamic> toJson(AudioMetadata metadata) {
    return {
      'album': metadata.album,
      'year': metadata.year?.toIso8601String(),
      'language': metadata.language,
      'artist': metadata.artist,
      'performers': metadata.performers,
      'title': metadata.title,
      'trackNumber': metadata.trackNumber,
      'trackTotal': metadata.trackTotal,
      'duration': metadata.duration?.inMilliseconds,
      'genres': metadata.genres,
      'discNumber': metadata.discNumber,
      'totalDisc': metadata.totalDisc,
      'lyrics': metadata.lyrics,
      'bitrate': metadata.bitrate,
      'sampleRate': metadata.sampleRate,
      //'pictures': metadata.pictures.map((p) => p.bytes).toList(),
      'file': metadata.file.path,
    };
  }

  static AudioMetadata fromJson(Map<String, dynamic> json) {
    final metadata = AudioMetadata(
      album: json['album'],
      year: json['year'] != null ? DateTime.parse(json['year']) : null,
      language: json['language'],
      artist: json['artist'],
      title: json['title'],
      trackNumber: json['trackNumber'],
      trackTotal: json['trackTotal'],
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : null,
      discNumber: json['discNumber'],
      totalDisc: json['totalDisc'],
      lyrics: json['lyrics'],
      bitrate: json['bitrate'],
      sampleRate: json['sampleRate'],
      file: File(json['file']),
    );

    if (json['performers'] != null) {
      metadata.performers.addAll(List<String>.from(json['performers']));
    }

    if (json['genres'] != null) {
      metadata.genres = List<String>.from(json['genres']);
    }

    return metadata;
  }
}

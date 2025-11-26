import 'dart:io';
import 'dart:typed_data';

class OneSong {
  final String album;
  final int year;
  final String artist;
  final String title;
  final int trackNumber;
  final int trackTotal;
  final Duration duration;
  final List<String> genres;
  final int discNumber;
  final int totalDisc;
  final String lyrics;
  final File file;
  final String? picture;

  OneSong({
    required this.album,
    required this.year,
    required this.artist,
    required this.title,
    required this.trackNumber,
    required this.trackTotal,
    required this.duration,
    required this.genres,
    required this.discNumber,
    required this.totalDisc,
    required this.lyrics,
    required this.file,
    required this.picture,
  });
}

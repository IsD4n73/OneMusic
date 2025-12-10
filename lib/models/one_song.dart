class OneSong {
  final String album;
  final String onlineId;
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
  final String file;
  final String? picture;
  final bool selected;

  OneSong({
    required this.onlineId,
    required this.selected,
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

  // from json
  factory OneSong.fromJson(Map<String, dynamic> json) {
    return OneSong(
      onlineId: json['onlineId'],
      album: json['album'],
      year: json['year'],
      artist: json['artist'],
      title: json['title'],
      trackNumber: json['trackNumber'],
      trackTotal: json['trackTotal'],
      duration: Duration(milliseconds: json['duration']),
      genres: List<String>.from(json['genres']),
      discNumber: json['discNumber'],
      totalDisc: json['totalDisc'],
      lyrics: json['lyrics'],
      file: json['file'],
      picture: json['picture'],
      selected: json['selected'],
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
    'onlineId': onlineId,
    'album': album,
    'year': year,
    'artist': artist,
    'title': title,
    'trackNumber': trackNumber,
    'trackTotal': trackTotal,
    'duration': duration.inMilliseconds,
    'genres': genres,
    'discNumber': discNumber,
    'totalDisc': totalDisc,
    'lyrics': lyrics,
    'file': file,
    'picture': picture,
    'selected': selected,
  };

  OneSong copyWith({required bool selected}) {
    return OneSong(
      onlineId: onlineId,
      album: album,
      year: year,
      artist: artist,
      title: title,
      trackNumber: trackNumber,
      trackTotal: trackTotal,
      duration: duration,
      genres: genres,
      discNumber: discNumber,
      totalDisc: totalDisc,
      lyrics: lyrics,
      file: file,
      picture: picture,
      selected: selected,
    );
  }
}

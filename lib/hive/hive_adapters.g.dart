// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class OneSongAdapter extends TypeAdapter<OneSong> {
  @override
  final typeId = 0;

  @override
  OneSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OneSong(
      selected: fields[13] as bool,
      album: fields[0] as String,
      year: (fields[1] as num).toInt(),
      artist: fields[2] as String,
      title: fields[3] as String,
      trackNumber: (fields[4] as num).toInt(),
      trackTotal: (fields[5] as num).toInt(),
      duration: fields[6] as Duration,
      genres: (fields[7] as List).cast<String>(),
      discNumber: (fields[8] as num).toInt(),
      totalDisc: (fields[9] as num).toInt(),
      lyrics: fields[10] as String,
      file: fields[11] as String,
      picture: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OneSong obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.album)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.trackNumber)
      ..writeByte(5)
      ..write(obj.trackTotal)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.genres)
      ..writeByte(8)
      ..write(obj.discNumber)
      ..writeByte(9)
      ..write(obj.totalDisc)
      ..writeByte(10)
      ..write(obj.lyrics)
      ..writeByte(11)
      ..write(obj.file)
      ..writeByte(12)
      ..write(obj.picture)
      ..writeByte(13)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OneSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OnePlaylistAdapter extends TypeAdapter<OnePlaylist> {
  @override
  final typeId = 1;

  @override
  OnePlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnePlaylist(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      picture: fields[2] as String?,
      songs: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OnePlaylist obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.picture)
      ..writeByte(3)
      ..write(obj.songs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnePlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

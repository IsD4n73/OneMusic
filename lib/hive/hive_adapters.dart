import 'package:hive_ce/hive.dart';
import 'package:one_music/models/one_playlist.dart';

import '../models/one_song.dart';

@GenerateAdapters([AdapterSpec<OneSong>(), AdapterSpec<OnePlaylist>()])
part 'hive_adapters.g.dart';

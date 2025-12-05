import 'dart:convert';
import 'dart:io';

import 'package:discord_rich_presence/discord_rich_presence.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:one_music/models/one_song.dart';

class OnePlayerController extends GetxController {
  final player = AudioPlayer();
  final Client richClient = Client(
    clientId: dotenv.env['RICH_CLIENT'] ?? "NULL",
  );
  Rx<OneSong?> playingSong = Rx<OneSong?>(null);
  RxBool isPlaying = RxBool(false);

  Future<void> loadPlaylist(List<OneSong> songs, int index) async {
    Get.log("loadPlaylist");
    try {
      await player.clearAudioSources();
      Get.log("loadPlaylist, clearing");
      ChatGPT

Accedi

Hai detto:
Con Just_audio in flutter la notifica del player esce vuota
ChatGPT ha detto:
Se la notifica del player di Just_audio su Flutter esce vuota (senza titolo, artista o controlli), quasi sempre il problema è che Just Audio da solo non gestisce le notifiche: serve il plugin audio_service oppure just_audio_background.

Qui sotto trovi le cause più comuni e come risolverle.

✅ Soluzione più comune: usare just_audio_background
A partire dalle versioni recenti, Just Audio non mostra più notifiche su Android/iOS senza just_audio_background.

1. Installa il plugin
dependencies:
  just_audio: ^your_version
  just_audio_background: ^0.0.1 # controlla versione attuale
2. Inizializzalo nel main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.app.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}
3. Imposta i metadati quando carichi l’audio
Se non imposti i metadati, la notifica risulterà vuota.

final player = AudioPlayer();
await player.setAudioSource(
  AudioSource.uri(
    Uri.parse("https://example.com/song.mp3"),
    tag: MediaItem(
      id: '1',
      album: 'Album name',
      title: 'Titolo della traccia',
      artist: 'Artista',
      artUri: Uri.parse("https://example.com/cover.jpg"),
    ),
  ),
);
→ Se il tag è mancante o incompleto, la notifica risulta vuota!

⚠️ Problemi comuni e soluzioni
1️⃣ Notifica appare ma senza testo → mancano i tag MediaItem
Serve SEMPRE impostare title, artist almeno.

2️⃣ Notifica non appare → permessi Android
Controlla il manifest:

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
Su Android 13+ potrebbe servire anche:

<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
3️⃣ Stai usando audio_service invece di just_audio_background
Con audio_service devi creare un BackgroundAudioHandler.
Se non lo fai, la notifica è vuota.

4️⃣ Notifica appare ma senza controlli (play/pause)
Succede quando il player non invia correttamente lo stato.

Assicurati di non usare AudioSource.uri senza tag.

📌 Vuoi che guardi il tuo codice e ti dico esattamente dove si rompe?
Incolla qui il file dove inizializzi il player e la parte del main: te lo sistemo in pochi minuti.

Hai detto:
Ho inserito just_audio_background e fatto quello che hai detto ma sempre vuota
ChatGPT ha detto:
Ok, allora andiamo diretti alla diagnosi reale: quando nonostante just_audio_background la notifica resta vuota, significa che uno dei tre punti sottostanti non sta funzionando:

✅ CHECKLIST CRITICA (il 99% dei casi è qui)
1️⃣ Il tag (MediaItem) NON viene letto
Anche se l’hai scritto nel codice, magari viene sovrascritto, caricato dopo, o non è nel punto giusto.

👉 Mostrami come stai caricando la traccia.

Il tag deve essere dentro setAudioSource, così:

await player.setAudioSource(
  AudioSource.uri(
    Uri.parse(url),
    tag: MediaItem(
      id: '1',
      title: 'Titolo',
      artist: 'Artista',
      album: 'Album',
      artUri: Uri.parse('https://...'),
    ),
  ),
);
Se lo metti dopo, o se usi setUrl(), la notifica rimarrà vuota.

2️⃣ JustAudioBackground.init() NON è nel punto giusto
Deve essere prima di runApp() e soprattutto prima di creare l’audio player.

Esempio corretto:

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.app.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}
Se l’hai messo dentro initState, in un service, o dopo runApp(), non funziona → notifica vuota.

3️⃣ Stai usando una versione recente di Android (13/14)
Su Android 13+ la notifica viene creata ma rimane invisibile o vuota se non si concede il permesso:

<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
E devi anche chiederlo runtime:

if (await Permission.notification.isDenied) {
  await Permission.notification.request();
}
🔍 4 cose che voglio vedere per capirci subito
Incollami questi pezzi di codice:

main.dart → dove inizializzi JustAudioBackground

dove crei il player

il tuo setAudioSource()

Eventuali log in console quando parte la riproduzione

Con questi 4 punti ti dico esattamente dov’è l’errore.

💡 (Bonus) Test rapido per capire se i tag funzionano
Prova questo codice minimo in un progetto nuovo:

final player = AudioPlayer();
await player.setAudioSource(
  AudioSource.uri(
    Uri.parse("https://example.com/audio.mp3"),
    tag: MediaItem(
      id: 'test',
      title: 'Test Title',
      artist: 'Test Artist',
    ),
  ),
);
player.play();
Se anche qui la notifica è vuota → il problema è configurazione o permessi.

📌 Incollami i file, te lo risolvo subito.

Hai detto:
await player.setAudioSources(
        songs
            .map(
              (e) => AudioSource.file(
                e.file,
                tag: MediaItem(
                  id: e.hashCode.toString(),
                  title: e.title,
                  album: e.album,
                  /*artUri: e.picture == null
                      ? null
                      : Uri.dataFromBytes(base64Decode(e.picture!)),*/
                  artist: e.artist,
                  duration: e.duration,
                  displayTitle: e.title,
                  displaySubtitle: e.artist,
                  extras: {"onesong": e},
                ),
              ),
            )
            .toList(),
        initialIndex: index,
      );

final playlist = ConcatenatingAudioSource(
  children: songs.map(
    (e) => AudioSource.file(
      e.file,
      tag: MediaItem(
        id: e.hashCode.toString(),
        title: e.title,
        album: e.album,
        artist: e.artist,
        duration: e.duration,
        displayTitle: e.title,
        displaySubtitle: e.artist,
        extras: {"onesong": e},
      ),
    ),
  ).toList(),
);

await player.setAudioSource(
  playlist,
  initialIndex: index,
);

      _setRichPresence(songs[index]);

      await player.play();
      Get.log("loadPlaylist, playing: ${player.playing}");
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Future<List<OneSong>> nextSong(List<OneSong> songs) async {
    await player.seekToNext();

    var source =
        player.audioSources[player.currentIndex ?? 0] as ProgressiveAudioSource;
    var mediaItem = source.tag as MediaItem;
    var song = mediaItem.extras?["onesong"] as OneSong;

    _setRichPresence(song);

    playingSong.value = song;

    Get.log("now playing: ${song.file}");
    return _refreshSongs(songs);
  }

  Future<List<OneSong>> previousSong(List<OneSong> songs) async {
    await player.seekToPrevious();

    var source =
        player.audioSources[player.currentIndex ?? 0] as ProgressiveAudioSource;
    var mediaItem = source.tag as MediaItem;
    var song = mediaItem.extras?["onesong"] as OneSong;

    _setRichPresence(song);

    playingSong.value = song;

    Get.log("now playing: ${playingSong.value?.file}");
    return _refreshSongs(songs);
  }

  void togglePlaySong() async {
    Get.log("togglePlaySong, playing: ${player.playing}");
    isPlaying.value = !player.playing;
    player.playing ? player.pause() : player.play();
  }

  List<OneSong> getPlayerSource() {
    return player.audioSources.map((e) {
      var source = player.audioSource as ProgressiveAudioSource;
      var mediaItem = source.tag as MediaItem;
      var song = mediaItem.extras?["onesong"] as OneSong;

      return song;
    }).toList();
  }

  List<OneSong> _refreshSongs(List<OneSong> songs) {
    List<OneSong> tmpSongs = [];

    for (var element in songs) {
      tmpSongs.add(element.copyWith(selected: false));
    }

    var index = tmpSongs.indexWhere(
      (element) => playingSong.value?.file == element.file,
    );
    tmpSongs[index] = tmpSongs[index].copyWith(selected: true);

    return tmpSongs;
  }

  void _setRichPresence(OneSong song) {
    if (Platform.isWindows) {
      Get.log("setRichPresence for ${song.title}");
      richClient.setActivity(
        Activity(
          name: song.title,
          details: song.artist,
          type: ActivityType.listening,
          timestamps: ActivityTimestamps(
            start: DateTime.now(),
            end: DateTime.now().add(song.duration),
          ),
        ),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (Platform.isWindows) {
      richClient.connect();
    }

    player.playbackEventStream.listen((event) {
      var currentIndex = event.currentIndex ?? 0;

      if (player.audioSources.isEmpty) return;

      var source = player.audioSources[currentIndex] as ProgressiveAudioSource;
      var mediaItem = source.tag as MediaItem;
      var song = mediaItem.extras?["onesong"] as OneSong;

      playingSong.value = song;

      Get.log("now playing: ${playingSong.value?.file}");
    });

    player.playerStateStream.listen((event) {
      Get.log("playerStateStream, playing: ${event.playing}");
      isPlaying.value = event.playing;
    });
  }
}

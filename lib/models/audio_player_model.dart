import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/song_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioPlayerModel {
  AudioPlayerModel._();
  static final AudioPlayerModel instance = AudioPlayerModel._();

  Stream<bool> get playingState => _audioPlayer.playingStream;
  ProcessingState get processingState => _audioPlayer.processingState;
  Stream<Duration> get positionState => positionStream();
  Duration? get duration => _audioPlayer.duration;
  Stream<int?> get index => _audioPlayer.currentIndexStream;
  Stream<LoopMode> get loopMode => _audioPlayer.loopModeStream;
  Stream<bool> get shuffleMode => _audioPlayer.shuffleModeEnabledStream;

  Stream<Duration> positionStream() async* {
    DateTime n = DateTime.now();
    DateTime n1 = DateTime.now();
    await for (final v in _audioPlayer.positionStream) {
      n1 = DateTime.now();
      if (seeking) {
        yield v;
      } else if (n1.difference(n).inSeconds >= 1) {
        n = n1;
        yield v;
      }
    }
  }

  bool seeking = false;

  final _audioPlayer = AudioPlayer();

  List<SongModel>? songs;

  static Future<List<dynamic>> _getSongs(String path) async {
    List<SongModel> s = [];

    Directory topDir = Directory(path.substring(0, path.indexOf('Android')));

    Stream<FileSystemEntity> files = topDir.list(recursive: true);
    List<FileSystemEntity> filesList = await files.toList();
    List<int> bytes;
    MP3Instance mp3instance;
    for (var element in filesList) {
      if (element is File &&
          (element.path.substring(element.path.length - 3).toLowerCase() ==
                  'mp3' ||
              element.path.substring(element.path.length - 3).toLowerCase() ==
                  'm4a')) {
        bytes = File(element.path).readAsBytesSync();
        mp3instance = MP3Instance(bytes);
        mp3instance.parseTagsSync();
        s.add(
          SongModel.fromJson(
            json: mp3instance.getMetaTags(),
            path: element.path,
          ),
        );
      }
    }

    s.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    List<UriAudioSource> songUris =
        s.map((e) => AudioSource.uri(Uri.parse(e.path))).toList();

    return [s, songUris];
  }

// {
//   "Title": "SongName",
//   "Artist": "ArtistName",
//   "Album": "AlbumName",
//   "APIC": {
//     "mime": "image/jpeg",
//     "textEncoding": "0",
//     "picType": "0",
//     "description": "description",
//     "base64": "AP/Y/+AAEEpGSUYAAQEBAE..."
//   }
// }

  Future<void> init(BuildContext ctx) async {
    if (!await Permission.storage.isGranted) {
      final perm = await Permission.storage.request();
      if (!perm.isGranted) {
        exit(0);
      }
    }

    Directory? mainDir = await getExternalStorageDirectory();
    if (mainDir == null) {
      exit(0);
    }

    List<dynamic> comp;
    comp = await compute<String, List<dynamic>>(_getSongs, mainDir.path);
    songs = comp[0] as List<SongModel>;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      debugPrint('A stream error occurred: $e');
    });
    try {
      // Try to load audio from a source and catch any errors.
      await _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: comp[1] as List<UriAudioSource>,
        ),
        initialIndex: null,
        initialPosition: Duration.zero,
        preload: false,
      );
      _audioPlayer.setLoopMode(LoopMode.all);
      _audioPlayer.setShuffleModeEnabled(false);
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  Future<void> changeLoopMode() async {
    if (_audioPlayer.loopMode == LoopMode.all) {
      await _audioPlayer.setLoopMode(LoopMode.one);
    } else if (_audioPlayer.loopMode == LoopMode.one) {
      await _audioPlayer.setLoopMode(LoopMode.off);
    } else {
      await _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  Future<void> setShuffleMode(bool shuffleMode) async {
    await _audioPlayer.setShuffleModeEnabled(shuffleMode);
  }

  Future<void> play(int index) async {
    await stop();
    await _audioPlayer.seek(Duration.zero, index: index);
    await resume();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> next() async {
    await stop();
    await _audioPlayer.seekToNext();
    await resume();
  }

  Future<void> previous() async {
    await stop();
    await _audioPlayer.seekToPrevious();
    await resume();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void changeSeeking(bool b) {
    seeking = b;
  }

  Future<void> seek(double pos) async {
    await _audioPlayer.seek(Duration(seconds: pos.toInt()));
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

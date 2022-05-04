import 'dart:io';

import 'package:audio_session/audio_session.dart';
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
  Stream<ProcessingState> get processingStateStream =>
      _audioPlayer.processingStateStream;
  ProcessingState get processingState => _audioPlayer.processingState;
  Stream<Duration> get positionState => _audioPlayer.positionStream;
  Duration? get duration => _audioPlayer.duration;
  Stream<int?> get index => _audioPlayer.currentIndexStream;
  Stream<LoopMode> get loopMode => _audioPlayer.loopModeStream;
  Stream<bool> get shuffleMode => _audioPlayer.shuffleModeEnabledStream;

  final _audioPlayer = AudioPlayer();

  List<SongModel>? songs;

  Future<List<SongModel>> _getSongs(BuildContext ctx) async {
    if (!await Permission.storage.isGranted) {
      final perm = await Permission.storage.request();
      if (!perm.isGranted) {
        exit(0);
      }
    }

    List<SongModel> s = [];

    Directory? mainDir = await getExternalStorageDirectory();
    if (mainDir == null) {
      exit(0);
    }

    Directory topDir =
        Directory(mainDir.path.substring(0, mainDir.path.indexOf('Android')));

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
        // if (mp3instance.parseTagsSync()) {
        mp3instance.parseTagsSync();
        s.add(
          SongModel.fromJson(
            json: mp3instance.getMetaTags(),
            path: element.path,
          ),
        );
        // }
      }
    }

    s.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return s;
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
    songs = await _getSongs(ctx);

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
          // Start loading next item just before reaching it.
          useLazyPreparation: true, // default
          // Customise the shuffle algorithm.
          shuffleOrder: DefaultShuffleOrder(), // default
          // Specify the items in the playlist.
          children:
              songs!.map((e) => AudioSource.uri(Uri.parse(e.path))).toList(),
        ),
        initialIndex: null,
        // Playback will be prepared to start from track1.mp3
        // Playback will be prepared to start from position zero.
        initialPosition: Duration.zero, // default
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
    // no looping (default)
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

  Future<void> seek(double pos) async {
    await _audioPlayer.seek(Duration(seconds: pos.toInt()));
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

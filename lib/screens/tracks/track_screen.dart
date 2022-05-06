import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/audio_player_model.dart';
import 'package:music_player/screens/play_screen.dart';
import 'package:music_player/screens/tracks/track_list.dart';
import 'package:music_player/utils/colors.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AudioPlayerModel.instance.init(context);
    setState(() {});
  }

  @override
  void dispose() {
    AudioPlayerModel.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Text(
          'GDSC Music Player',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          StreamBuilder(
            stream: AudioPlayerModel.instance.shuffleMode,
            builder: (contect, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  icon: const Icon(
                    Icons.shuffle_on_outlined,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await AudioPlayerModel.instance.setShuffleMode(false);
                  },
                );
              }
              return IconButton(
                icon: const Icon(
                  Icons.shuffle_outlined,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await AudioPlayerModel.instance.setShuffleMode(true);
                },
              );
            },
          ),
          StreamBuilder(
            stream: AudioPlayerModel.instance.loopMode,
            builder: (contect, AsyncSnapshot<LoopMode> snapshot) {
              if (snapshot.data == LoopMode.all) {
                return IconButton(
                  icon: const Icon(
                    Icons.repeat_on_rounded,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await AudioPlayerModel.instance.changeLoopMode();
                  },
                );
              }

              if (snapshot.data == LoopMode.one) {
                return IconButton(
                  icon: const Icon(
                    Icons.repeat_one_on_rounded,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await AudioPlayerModel.instance.changeLoopMode();
                  },
                );
              }

              return IconButton(
                icon: const Icon(
                  Icons.repeat_rounded,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await AudioPlayerModel.instance.changeLoopMode();
                },
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        child: AudioPlayerModel.instance.songs == null
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : AudioPlayerModel.instance.songs!.isEmpty
                ? const Center(
                    child: Text("You have no audio files"),
                  )
                : const TrackList(),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AudioPlayerModel.instance.songs == null ||
              AudioPlayerModel.instance.songs!.isEmpty
          ? null
          : StreamBuilder(
              stream: AudioPlayerModel.instance.index,
              builder: ((context, AsyncSnapshot<int?> snapshot) {
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const PlayScreen();
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(90))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: AudioPlayerModel.instance
                                      .songs![snapshot.data ?? 0].imageBase64 ==
                                  null
                              ? Hero(
                                  tag: AudioPlayerModel.instance
                                      .songs![snapshot.data ?? 0].title,
                                  child: Image.asset(
                                    'assets/icon.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                )
                              : Hero(
                                  tag: AudioPlayerModel.instance
                                      .songs![snapshot.data ?? 0].title,
                                  child: Image.memory(
                                    base64Decode(AudioPlayerModel
                                        .instance
                                        .songs![snapshot.data ?? 0]
                                        .imageBase64!),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AudioPlayerModel.instance
                                        .songs![snapshot.data ?? 0].title
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    AudioPlayerModel.instance
                                        .songs![snapshot.data ?? 0].title
                                        .substring(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(.95),
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                AudioPlayerModel.instance
                                        .songs![snapshot.data ?? 0].artist
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    AudioPlayerModel.instance
                                        .songs![snapshot.data ?? 0].artist
                                        .substring(1),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.95),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            await AudioPlayerModel.instance.previous();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.skip_previous_rounded,
                              size: 30,
                              color: Colors.white.withOpacity(.95),
                            ),
                          ),
                        ),
                        StreamBuilder(
                            stream: AudioPlayerModel.instance.playingState,
                            builder: (context, AsyncSnapshot<bool> snapshot1) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    snapshot1.data != null && snapshot1.data!
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 30,
                                    color: Colors.white.withOpacity(.95),
                                  ),
                                ),
                                onTap: () async {
                                  if (snapshot1.data != null &&
                                      snapshot1.data!) {
                                    await AudioPlayerModel.instance.pause();
                                  } else if (AudioPlayerModel
                                          .instance.processingState ==
                                      ProcessingState.ready) {
                                    await AudioPlayerModel.instance.resume();
                                  } else {
                                    await AudioPlayerModel.instance
                                        .play(snapshot.data ?? 0);
                                  }
                                },
                              );
                            }),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.skip_next_rounded,
                              size: 30,
                              color: Colors.white.withOpacity(.95),
                            ),
                          ),
                          onTap: () async {
                            await AudioPlayerModel.instance.next();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

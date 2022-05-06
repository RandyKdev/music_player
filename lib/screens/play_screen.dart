import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/audio_player_model.dart';
import 'package:music_player/utils/colors.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 110,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black54,
            size: 35,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              primaryColor,
              scaffoldBackgroundColor,
            ],
            center: Alignment(-.5, .9),
            radius: 1.1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: StreamBuilder(
                  stream: AudioPlayerModel.instance.index,
                  builder: ((context, AsyncSnapshot<int?> snapshot) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            clipBehavior: Clip.hardEdge,
                            height: 150.0,
                            width: 150.0,
                            child: AudioPlayerModel
                                        .instance
                                        .songs![snapshot.data ?? 0]
                                        .imageBase64 ==
                                    null
                                ? Hero(
                                    tag: AudioPlayerModel.instance
                                        .songs![snapshot.data ?? 0].title,
                                    child: Image.asset(
                                      'assets/icon.png',
                                      height: 150,
                                      width: 150,
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
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          child: Text(
                            AudioPlayerModel
                                    .instance.songs![snapshot.data ?? 0].title
                                    .substring(0, 1)
                                    .toUpperCase() +
                                AudioPlayerModel
                                    .instance.songs![snapshot.data ?? 0].title
                                    .substring(1),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ), //can add the text shrink thingy here
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            AudioPlayerModel
                                    .instance.songs![snapshot.data ?? 0].artist
                                    .substring(0, 1)
                                    .toUpperCase() +
                                AudioPlayerModel
                                    .instance.songs![snapshot.data ?? 0].artist
                                    .substring(1),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Column(
              children: [
                StreamBuilder<Duration?>(
                  stream: AudioPlayerModel.instance.positionState,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 5.0, right: 5.0, bottom: 0),
                          child: Slider.adaptive(
                            value: snapshot.hasData
                                ? snapshot.data!.inSeconds.toDouble()
                                : 0.toDouble(),
                            thumbColor: Colors.white,
                            min: 0,
                            max: AudioPlayerModel.instance.duration?.inSeconds
                                    .toDouble() ??
                                0.toDouble(),
                            onChanged: (value) async {
                              await AudioPlayerModel.instance.seek(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 28.0, right: 28.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.hasData
                                    ? snapshot.data!.toString().substring(
                                          0,
                                          snapshot.data!
                                              .toString()
                                              .indexOf('.'),
                                        )
                                    : '00:00',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                AudioPlayerModel.instance.duration != null
                                    ? AudioPlayerModel.instance.duration
                                        .toString()
                                        .substring(
                                          0,
                                          AudioPlayerModel.instance.duration
                                              .toString()
                                              .indexOf('.'),
                                        )
                                    : '00:00',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: AudioPlayerModel.instance.shuffleMode,
                        builder: (contect, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData && snapshot.data!) {
                            return InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.shuffle_on_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                await AudioPlayerModel.instance
                                    .setShuffleMode(false);
                              },
                            );
                          }
                          return InkWell(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.shuffle_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              await AudioPlayerModel.instance
                                  .setShuffleMode(true);
                            },
                          );
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.skip_previous_rounded,
                            size: 30,
                            color: Colors.white.withOpacity(.95),
                          ),
                        ),
                        onTap: () async {
                          await AudioPlayerModel.instance.previous();
                        },
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
                                  size: 45,
                                  color: Colors.white.withOpacity(.95),
                                ),
                              ),
                              onTap: () async {
                                if (snapshot1.data != null && snapshot1.data!) {
                                  await AudioPlayerModel.instance.pause();
                                } else {
                                  await AudioPlayerModel.instance.resume();
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
                      StreamBuilder(
                        stream: AudioPlayerModel.instance.loopMode,
                        builder: (contect, AsyncSnapshot<LoopMode> snapshot) {
                          if (snapshot.data == LoopMode.all) {
                            return InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.repeat_on_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                await AudioPlayerModel.instance
                                    .changeLoopMode();
                              },
                            );
                          }

                          if (snapshot.data == LoopMode.one) {
                            return InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.repeat_one_on_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                await AudioPlayerModel.instance
                                    .changeLoopMode();
                              },
                            );
                          }

                          return InkWell(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.repeat_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              await AudioPlayerModel.instance.changeLoopMode();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_player/models/audio_player_model.dart';
import 'package:music_player/models/song_model.dart';

class MusicTile extends StatelessWidget {
  final SongModel song;
  final int index;
  const MusicTile({
    Key? key,
    required this.song,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await AudioPlayerModel.instance.play(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: Row(children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: song.imageBase64 == null
                  ? Image.asset(
                      song.fallBackImage,
                      height: 50,
                      width: 50,
                    )
                  : Image.memory(
                      base64Decode(song.imageBase64!),
                      height: 50,
                      width: 50,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title.substring(0, 1).toUpperCase() +
                        song.title.substring(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist.substring(0, 1).toUpperCase() +
                        song.artist.substring(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.more_vert_rounded,
            //     color: Colors.black54,
            //   ),
            // )
          ]),
        ));
  }
}

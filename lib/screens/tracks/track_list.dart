import 'package:flutter/material.dart';
import 'package:music_player/models/audio_player_model.dart';
import 'package:music_player/screens/tracks/music_tile.dart';

class TrackList extends StatelessWidget {
  const TrackList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: AudioPlayerModel.instance.songs!.length + 1,
      itemBuilder: (context, index) {
        if (index == AudioPlayerModel.instance.songs!.length) {
          return const SizedBox(height: 100);
        }
        return MusicTile(
          song: AudioPlayerModel.instance.songs![index],
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        if (index == AudioPlayerModel.instance.songs!.length - 1) {
          return Container();
        }
        return const Divider(
          indent: 70,
          height: 0,
          color: Color.fromARGB(255, 145, 142, 142),
        );
      },
    );
  }
}

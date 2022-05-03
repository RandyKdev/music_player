import 'package:flutter/material.dart';
import 'package:music_player/Music/music.dart';
import 'package:music_player/screens/tracks/musicTile.dart';

class TrackList extends StatefulWidget {
  const TrackList({Key? key}) : super(key: key);

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              MusicTile(
                title: songs[index].title,
                author: songs[index].author,
                image: songs[index].image,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 10),
                child: index == songs.length - 1
                    ? Container()
                    : const Divider(
                        color: Color.fromARGB(255, 145, 142, 142),
                      ),
              ),
            ],
          );
        });
  }
}

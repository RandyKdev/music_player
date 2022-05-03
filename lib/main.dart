import 'package:flutter/material.dart';
import 'package:music_player/screens/track_screen.dart';


import 'package:music_player/screens/tracks/trackScreen.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const TrackScreen(),
    );
  }
}

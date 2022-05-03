import 'package:flutter/material.dart';

import 'package:music_player/screens/tracks/trackScreen.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  
      home: TrackScreen(),
    );
  }
}

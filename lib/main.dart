import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:music_player/screens/tracks/track_screen.dart';
import 'package:music_player/utils/colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          secondary: primaryColor,
          brightness: Brightness.light,
          primary: scaffoldBackgroundColor,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          background: scaffoldBackgroundColor,
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      home: const TrackScreen(),
    );
  }
}

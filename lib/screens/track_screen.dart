import 'package:flutter/material.dart';
import 'package:music_player/utils/colors.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
          title: const Text(
            'Tracks',
            style: TextStyle(fontWeight: FontWeight.bold,
            color: midColor,
            ),
          ),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.search,
              color: midColor,
              ),
            ),
             IconButton(
              onPressed: null,
              icon: Icon(Icons.more_vert_rounded, 
              color: midColor,             
              ),
            ),
          ]),
    );
  }
}

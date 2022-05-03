import 'package:flutter/material.dart';
import 'package:music_player/screens/tracks/trackList.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 240, 239, 239),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(children: [
              Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Music ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 92, 87, 87),
                          fontSize: 30),
                      children: [
                        TextSpan(
                          text: 'Player',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Color.fromARGB(255, 92, 87, 87),
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  text: 'Tracks',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Color.fromARGB(255, 61, 60, 60)),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Expanded(
                child: Container(
              width: screenSize.width,
              child: TrackList(),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: screenSize.width - 30,
        height: 80,
        decoration:const  BoxDecoration(
            color: Color.fromARGB(255, 123, 85, 129),
            borderRadius: BorderRadius.all(Radius.circular(90))),
        child: ListTile(
           leading: const Icon(Icons.music_note, size: 40,color: Colors.white),
          title: Row(
            children: [
             const  Text("Best song ever" , style: TextStyle(color: Colors.white),),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 20,
                    color: Colors.white
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.pause,
                    size: 20,
                    color: Colors.white
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next, size: 20, color: Colors.white,))
            ],
          ),
          subtitle: const  Text("janWICKEDpro", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({ Key? key }) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Music Player'),
        automaticallyImplyLeading: false,
      ),
      body: const PlaySreenBody(),
    );
  }
}

class PlaySreenBody extends StatefulWidget {
  const PlaySreenBody({ Key? key }) : super(key: key);

  @override
  State<PlaySreenBody> createState() => _PlaySreenBodyState();
}

class _PlaySreenBodyState extends State<PlaySreenBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
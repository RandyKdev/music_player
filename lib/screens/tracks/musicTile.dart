import 'package:flutter/material.dart';

class MusicTile extends StatefulWidget {
 final String? title;
 final String? author;
 final Image? image;
   const MusicTile({ Key? key, this.author, this.image, this.title}) : super(key: key);

  @override
  State<MusicTile> createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
          leading: widget.image,
          title: Text(widget.title!),
          subtitle: Text(widget.author!),
          trailing:IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
          onTap: (){
            //todo: open play page???
          },
      ),
    );
  }
}
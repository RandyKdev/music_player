
import 'package:flutter/material.dart';

class Music {
  String? title;
  String? author;
  Image? image;


  Music({required this.title, required this.author, this.image});

}

List<Music> songs = [
  Music(title: "Man go see all kind thing", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "If them born you well", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "If them no born you well", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "If it sure for you", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "If it no sure for you", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "Glory glory", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "For how??????", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "Beef", author: "Ya Boy", image: Image.asset('assets/icon.png')),
  
  Music(title: "Beef", author: "Ya Boy", image: Image.asset('assets/icon.png')),
];
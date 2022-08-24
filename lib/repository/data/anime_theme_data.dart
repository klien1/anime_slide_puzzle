import 'package:flutter/material.dart';

class AnimePuzzleData {
  const AnimePuzzleData();

  Map<String, Map<String, Object>> fetchData() {
    return animeImageList;
  }
}

// source: https://wall.alphacoders.com/big.php?i=1143485
// image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
// image: AssetImage('images/demon_slayer_background.jpg'),
// source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
// image: AssetImage('images/spy-x-family-background2.jpg'),
// source: https://wall.alphacoders.com/big.php?i=1227567

const Map<String, Map<String, Object>> animeImageList = {
  'spy_x_family': {
    'logo': 'images/Spy_×_Family_logo.png',
    'puzzle': 'images/spy-x-family.webp',
    'background': 'images/spy-x-family-background3-no-logo.jpg',
    'puzzleBackground': 'images/spy-x-family-background3-no-characters.jpg',
    'primarySwatch': Colors.teal,
    'textButtonPrimary': Colors.white,
    'textButtonBackgroundColor': Colors.orange,
    'bodyText2Color': Colors.black
  },
  'demon_slayer': {
    'logo': 'images/demon_slayer_logo.png',
    'puzzle': 'images/demon_slayer1.jpg',
    'background': 'images/demon_slayer_background_flipped.jpg',
    'puzzleBackground': 'images/demon_slayer_background_no_characters3.png',
    'primarySwatch': Colors.purple,
    'elevatedButtonPrimary': Color(0xFFb13dde),
    'elevatedButtonOnPrimary': Color(0xFFffceff),
    'textButtonPrimary': Color(0xFF2b0f7e),
    'textButtonBackgroundColor': Color(0xFFffceff),
    'bodyText2Color': Color(0xFFffceff),
  },
  'jujutsu_kaisen': {
    'logo': 'images/jujutsu_kaisen_logo.jpg',
    'puzzle': 'images/jujutsu_kaisen.jpg',
    'background': 'images/jujutsu_kaisen_background2_flipped.jpg',
    'puzzleBackground': 'images/jujutsu_kaisen_background2_no_characters.png',
    'primarySwatch': Colors.red,
    'elevatedButtonPrimary': Colors.black,
    'textButtonPrimary': Colors.white,
    'textButtonBackgroundColor': Color(0xFF8b0508),
  },
};

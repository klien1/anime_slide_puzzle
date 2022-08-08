import 'package:flutter/material.dart';

class AnimeTheme {
  AnimeTheme({
    required this.logoImagePath,
    required this.backgroundImagePath,
    required this.puzzleImagePath,
    required this.index,
    this.puzzleBackgroundImagePath,
    this.primarySwatch,
    this.backgroundColor,
    this.flipImage,
  });

  final String logoImagePath;
  final String backgroundImagePath;
  final String puzzleImagePath;
  final int index;

  final String? puzzleBackgroundImagePath;
  final MaterialColor? primarySwatch;
  final Color? backgroundColor;
  final bool? flipImage;
}

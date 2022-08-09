import 'package:flutter/material.dart';

class AnimeTheme {
  AnimeTheme({
    required this.name,
    required this.logoImagePath,
    required this.backgroundImagePath,
    required this.puzzleImagePath,
    required this.index,
    this.puzzleBackgroundImagePath,
    this.primarySwatch,
    this.backgroundColor,
    this.elevatedButtonPrimary,
    this.elevatedButtonOnPrimary,
    this.textButtonPrimary,
    this.textButtonBackgroundColor,
    this.bodyText2Color,
  });

  final String name;
  final String logoImagePath;
  final String backgroundImagePath;
  final String puzzleImagePath;
  final int index;

  final String? puzzleBackgroundImagePath;
  final MaterialColor? primarySwatch;
  final Color? backgroundColor;

  final Color? elevatedButtonPrimary;
  final Color? elevatedButtonOnPrimary;
  final Color? textButtonPrimary;
  final Color? textButtonBackgroundColor;
  final Color? bodyText2Color;
}

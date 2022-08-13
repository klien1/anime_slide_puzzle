import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// preloads all images from selection screen
Future<void> preloadSelectionLogos(
    {required BuildContext context, required mounted}) async {
  AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
  for (int i = 0; i < animeThemeList.listLength; ++i) {
    try {
      await precacheImage(
        AssetImage(animeThemeList.getAnimeThemeAtIndex(i).logoImagePath),
        context,
      );
    } catch (e) {
      print(e);
    }
  }
}

Future<void> preloadSelectionBackground({required BuildContext context}) async {
  AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
  for (int i = 0; i < animeThemeList.listLength; ++i) {
    try {
      await precacheImage(
        AssetImage(animeThemeList.getAnimeThemeAtIndex(i).backgroundImagePath),
        context,
      );
    } catch (e) {
      print(e);
    }
  }
}

Future<void> preloadPuzzleBackground({required BuildContext context}) async {
  AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
  for (int i = 0; i < animeThemeList.listLength; ++i) {
    try {
      await precacheImage(
        AssetImage(
            animeThemeList.getAnimeThemeAtIndex(i).puzzleBackgroundImagePath!),
        context,
      );
    } catch (e) {
      print(e);
    }
  }
}

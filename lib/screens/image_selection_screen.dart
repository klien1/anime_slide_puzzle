import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_landscape.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_portrait.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/constants.dart';

class ImageSelectionScreen extends StatefulWidget {
  const ImageSelectionScreen({Key? key}) : super(key: key);

  static const String id = 'image_selection_id';

  @override
  State<ImageSelectionScreen> createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  void _preloadImages() {
    if (MediaQuery.of(context).size.width > small) {
      _preloadCharacterBackground();
    } else {
      _preloadNoCharacterBackground();
    }
    _preloadPuzzleImage();
  }

  void _preloadCharacterBackground() {
    final AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();
    for (int i = 0; i < animeThemeList.listLength; ++i) {
      precacheImage(
        AssetImage(animeThemeList.getAnimeThemeAtIndex(i).backgroundImagePath),
        context,
      );
    }
    precacheImage(
      AssetImage(animeThemeList
          .getAnimeThemeAtIndex(animeThemeList.curIndex)
          .puzzleBackgroundImagePath!),
      context,
    );
  }

  void _preloadNoCharacterBackground() {
    final AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();
    for (int i = 0; i < animeThemeList.listLength; ++i) {
      precacheImage(
        AssetImage(
            animeThemeList.getAnimeThemeAtIndex(i).puzzleBackgroundImagePath!),
        context,
      );
    }
  }

  void _preloadPuzzleImage() {
    final AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();
    precacheImage(AssetImage(animeThemeList.curPuzzle), context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ChangeNotifierProvider<NumberPuzzleTiles>(
        create: (BuildContext context) => NumberPuzzleTiles(),
        child: Scaffold(
            body: (constraints.maxWidth > constraints.maxHeight)
                ? const ImageSelectionLayoutLandscape()
                : const ImageSelectionLayoutPortrait()),
      );
    });
  }
}

import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_landscape.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_portrait.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
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
  }

  void _preloadCharacterBackground() async {
    if (!mounted) return;
    final AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();
    for (int i = 0; i < animeThemeList.listLength; ++i) {
      if (!mounted) break;
      precacheImage(
        AssetImage(animeThemeList.getAnimeThemeAtIndex(i).backgroundImagePath),
        context,
      );
    }
    if (!mounted) return;
    precacheImage(
      AssetImage(animeThemeList
          .getAnimeThemeAtIndex(animeThemeList.curIndex)
          .puzzleBackgroundImagePath!),
      context,
    );
  }

  void _preloadNoCharacterBackground() {
    if (!mounted) return;
    final AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();
    for (int i = 0; i < animeThemeList.listLength; ++i) {
      if (!mounted) break;
      precacheImage(
        AssetImage(
            animeThemeList.getAnimeThemeAtIndex(i).puzzleBackgroundImagePath!),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > constraints.maxHeight) {
        return const ImageSelectionLayoutLandscape();
      } else {
        return const ImageSelectionLayoutPortrait();
      }
    });
  }
}

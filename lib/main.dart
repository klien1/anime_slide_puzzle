import 'package:anime_slide_puzzle/constants.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/background_image.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:anime_slide_puzzle/screens/welcome_screen.dart';
import 'models/puzzle_board.dart';
import 'models/number_puzzle_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

const String defaultImage = 'images/demon_slayer_background.jpg';
const int defaultBoardSize = 4;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProviders = [
      ChangeNotifierProvider<AnimeThemeList>(
          create: (context) => AnimeThemeList(animeImageList: animeImageList)),
      // ChangeNotifierProvider(create: (context) => PuzzleImageSelector()),
      // ChangeNotifierProvider(
      //     create: (context) => BackgroundImage(curImagePath: defaultImage)),
      // ChangeNotifierProxyProvider<AnimeThemeList, BackgroundImage>(
      //   create: (context) => BackgroundImage(
      //       curImagePath: context.read<AnimeThemeList>().curBackground),
      //   update: ((context, value, previous) =>
      //       BackgroundImage(curImagePath: value.curBackground)),
      // ),
      ChangeNotifierProvider<NumberPuzzleTiles>(
        create: (BuildContext context) => NumberPuzzleTiles(),
      ),
      ChangeNotifierProxyProvider<NumberPuzzleTiles, PuzzleBoard>(
        create: (BuildContext context) => PuzzleBoard(
            numRowsOrColumns:
                context.read<NumberPuzzleTiles>().currentNumberOfTiles),
        update: ((context, value, previous) =>
            PuzzleBoard(numRowsOrColumns: value.currentNumberOfTiles)),
      ),
    ];

    return MultiProvider(
      providers: myProviders,
      child: MaterialApp(
        title: 'Anime Slide Puzzle',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: ImageSelectionScreen.id,
        routes: {
          GameScreen.id: (context) => const GameScreen(),
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          ImageSelectionScreen.id: (context) => const ImageSelectionScreen(),
        },
      ),
      // ),
    );
  }
}

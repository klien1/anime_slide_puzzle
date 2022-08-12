// import 'dart:html';

import 'package:anime_slide_puzzle/constants.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProviders = [
      ChangeNotifierProvider<GameTimer>(
          create: (BuildContext context) => GameTimer()),
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
      ChangeNotifierProvider<AnimeThemeList>(
          create: (context) => AnimeThemeList(animeImageList: animeImageList),
          builder: (context, child) {
            final animeTheme = context.watch<AnimeThemeList>().curAnimeTheme;

            return MaterialApp(
              title: 'Anime Slide Puzzle',
              theme: ThemeData(
                primarySwatch: animeTheme.primarySwatch,
                scaffoldBackgroundColor: animeTheme.backgroundColor,
                iconTheme:
                    IconThemeData(color: animeTheme.bodyText2Color, size: 25),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    primary: animeTheme.elevatedButtonPrimary,
                    onPrimary: animeTheme.elevatedButtonOnPrimary,
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: animeTheme.textButtonPrimary,
                    backgroundColor: animeTheme.textButtonBackgroundColor,
                    elevation: 2,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                textTheme: TextTheme(
                  bodyText2: TextStyle(
                    color: animeTheme.bodyText2Color,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ),
              initialRoute: Welcome.id,
              routes: {
                GameScreen.id: (context) => const GameScreen(),
                ImageSelectionScreen.id: (context) =>
                    const ImageSelectionScreen(),
                Welcome.id: (context) => const Welcome(),
              },
            );
          }),
    ];

    return MultiProvider(providers: myProviders);
  }
}

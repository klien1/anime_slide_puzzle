// import 'dart:ui';

import 'package:anime_slide_puzzle/constants.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
// import 'package:anime_slide_puzzle/screens/welcome_screen.dart';
import 'models/puzzle_board.dart';
import 'models/number_puzzle_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// const String defaultImage = 'images/demon_slayer_background.jpg';
// const int defaultBoardSize = 4;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProviders = [
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
                // primaryColor: Colors.amber,
                primarySwatch: animeTheme.primarySwatch,
                scaffoldBackgroundColor: animeTheme.backgroundColor,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                ),

                //animeTheme.primarySwatch,
                // primarySwatch: Color(0xFF112233) //Colors.blue,
                // primaryColor: kPrimarySwatchColor,
                // colorScheme: ,
                // textButtonTheme: TextButtonThemeData(
                //   style: ButtonStyle(textStyle: )
                // ),
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.amber,
                  // textTheme: ButtonTextTheme.primary,
                ),
                textTheme: TextTheme(
                  button: TextStyle(color: Colors.amber),
                  bodyText2: TextStyle(
                    // color: context.read<AnimeThemeList>().color,
                    // color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              initialRoute: ImageSelectionScreen.id,
              routes: {
                GameScreen.id: (context) => const GameScreen(),
                ImageSelectionScreen.id: (context) =>
                    const ImageSelectionScreen(),
              },
            );
          }),
    ];

    // const MaterialColor kPrimarySwatchColor = Colors.orange;

    return MultiProvider(
      providers: myProviders,
      // child: MaterialApp(
      //   title: 'Anime Slide Puzzle',
      //   theme: ThemeData(
      //       // primarySwatch: Colors.blue,
      //       // primarySwatch: Color(0xFF112233) //Colors.blue,
      //       primaryColor: kPrimarySwatchColor,
      //       // colorScheme: ,
      //       textTheme: TextTheme(
      //           bodyText2: TextStyle(
      //               color: context.read<AnimeThemeList>().color,
      //               // color: Colors.white,
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold))),
      //   initialRoute: ImageSelectionScreen.id,
      //   routes: {
      //     GameScreen.id: (context) => const GameScreen(),
      //     ImageSelectionScreen.id: (context) => const ImageSelectionScreen(),
      //   },
      // ),
      // ),
    );
  }
}

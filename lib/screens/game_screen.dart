import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
// import 'package:anime_slide_puzzle/models/puzzleSolver/testing_hash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_image_selector.dart';
import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';

import 'package:anime_slide_puzzle/constants.dart';

// const int initialNumTilesPerRowOrColumn = 4;
const double gameBoardWidthAndHeight = 600;
const double padding = 5;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    final myProviders = [
      ChangeNotifierProvider<NumberPuzzleTiles>(
        create: (BuildContext context) => NumberPuzzleTiles(),
      ),
      ChangeNotifierProxyProvider<NumberPuzzleTiles, PuzzleBoard>(
        create: (BuildContext context) => PuzzleBoard(numRowsOrColumns: 2),
        update: ((context, value, previous) =>
            PuzzleBoard(numRowsOrColumns: value.currentNumberOfTiles)),
      ),
      ChangeNotifierProvider<PuzzleImageSelector>(
        create: (BuildContext context) => PuzzleImageSelector(imageList[0]),
      ),
    ];

    return MultiProvider(
      providers: myProviders,
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const GameImageSelector(),
              Column(
                children: const [
                  SelectBoardSize(),
                  GameBoard(
                    gameBoardWidthAndHeight: gameBoardWidthAndHeight,
                    tilePadding: padding,
                  ),
                ],
              ),
              const GameButtonControls(),
            ],
          ),
        ),
      ),
    );
  }
}

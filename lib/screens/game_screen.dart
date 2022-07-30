import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_image_selector.dart';
import 'package:anime_slide_puzzle/components/select_number_tiles.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';

// const int initialNumTilesPerRowOrColumn = 4;
const double gameBoardWidthAndHeight = 600;
const double padding = 5;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NumberPuzzleTiles>(
          create: (BuildContext context) => NumberPuzzleTiles(),
        ),
        ChangeNotifierProxyProvider<NumberPuzzleTiles, PuzzleBoard>(
          create: (BuildContext context) => PuzzleBoard(4),
          update: ((context, value, previous) =>
              PuzzleBoard(value.currentNumberOfTiles)),
        ),
        ChangeNotifierProvider<PuzzleImageSelector>(
          create: (BuildContext context) =>
              PuzzleImageSelector('images/demon_slayer1.jpg'),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const GameImageSelector(),
              Column(
                children: const [
                  SelectNumberTiles(),
                  GameBoard(
                    gameBoardWidthAndHeight: gameBoardWidthAndHeight,
                    tilePadding: padding,
                  ),
                ],
              ),
              const GameButtonControls()
            ],
          ),
        ),
      ),
    );
  }
}

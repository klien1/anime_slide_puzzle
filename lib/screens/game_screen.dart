import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';

const double gameWidth = 500;
const double gameHeight = 500;
const double padding = 5;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final myProviders = [
      ChangeNotifierProvider<NumberPuzzleTiles>(
        create: (BuildContext context) => NumberPuzzleTiles(),
      ),
      ChangeNotifierProxyProvider<NumberPuzzleTiles, PuzzleBoard>(
        create: (BuildContext context) => PuzzleBoard(
          numRowsOrColumns:
              Provider.of<NumberPuzzleTiles>(context, listen: false)
                  .currentNumberOfTiles,
        ),
        update: ((context, value, previous) =>
            PuzzleBoard(numRowsOrColumns: value.currentNumberOfTiles)),
      ),
    ];

    return MultiProvider(
      providers: myProviders,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SelectBoardSize(),
                  GameBoard(
                    width: gameWidth,
                    height: gameHeight,
                    tilePadding: padding,
                  ),
                  GameButtonControls(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

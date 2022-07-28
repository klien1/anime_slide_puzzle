import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int boardSize = 4;
const double dimension = 100;
const double padding = 20;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PuzzleBoard(boardSize),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: GameBoard(
                boardSize: boardSize,
                dimension: dimension,
                padding: padding,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

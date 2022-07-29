import 'package:anime_slide_puzzle/components/create_puzzle_piece.dart';
import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_image_selector.dart';

const int boardSize = 3;
// const double tileDimension = 100;
const double boardDimension = 500;
const double padding = 10;
// TODO: CHANGE DIMENSION LOGIC

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PuzzleBoard>(
          create: (BuildContext context) => PuzzleBoard(boardSize),
        ),
        ChangeNotifierProvider<PuzzleImageChanger>(
          create: (BuildContext context) =>
              PuzzleImageChanger('images/spy-x-family.webp'),
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameBoard(
                boardSize: boardSize,
                // tileDimension: tileDimension,
                boardDimension: boardDimension,
                padding: padding,
              ),
              GameImageSelector(),
              // CreatePuzzlePiece()
            ],
          ),
        ),
      ),
    );
  }
}

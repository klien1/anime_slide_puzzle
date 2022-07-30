import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_image_selector.dart';

const int numTilesPerRowOrColumn = 4;
const double gameBoardWidthAndHeight = 600;
const double padding = 5;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PuzzleBoard>(
          create: (BuildContext context) => PuzzleBoard(numTilesPerRowOrColumn),
        ),
        ChangeNotifierProvider<PuzzleImageChanger>(
          create: (BuildContext context) =>
              PuzzleImageChanger('images/spy-x-family.webp'),
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: const [
              GameBoard(
                gameBoardWidthAndHeight: gameBoardWidthAndHeight,
                padding: padding,
              ),
              GameImageSelector(),
            ],
          ),
        ),
      ),
    );
  }
}

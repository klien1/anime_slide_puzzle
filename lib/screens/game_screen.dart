import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_large.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_small.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_medium.dart';
import 'package:anime_slide_puzzle/utils/responsive_layout_helper.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static String id = 'game_screen_id';
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: GameBoardLayoutSmall(
          puzzleWidth: 350,
          puzzleHeight: 350,
          puzzlePadding: 5,
        ),
        tablet: GameBoardLayoutMedium(
          puzzleWidth: 300,
          puzzleHeight: 300,
          puzzlePadding: 5,
        ),
        web: GameBoardLayoutMedium(
          puzzleWidth: 300,
          puzzleHeight: 300,
          puzzlePadding: 5,
        ));
  }
}

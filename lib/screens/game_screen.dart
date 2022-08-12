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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double smallScreenPercentage = 0.75;
    const double mediumScreenPercentage = 0.6;
    const double largeScreenPercentage = 0.8;

    return ResponsiveLayout(
        mobile: (screenHeight < screenWidth)
            ? GameBoardLayoutSmall(
                puzzleWidth: screenHeight * smallScreenPercentage,
                puzzleHeight: screenHeight * smallScreenPercentage,
                puzzlePadding: 5,
              )
            : GameBoardLayoutSmall(
                puzzleWidth: screenWidth * smallScreenPercentage,
                puzzleHeight: screenWidth * smallScreenPercentage,
                puzzlePadding: 5,
              ),
        tablet: (screenHeight < screenWidth)
            ? GameBoardLayoutMedium(
                puzzleWidth: screenHeight * mediumScreenPercentage,
                puzzleHeight: screenHeight * mediumScreenPercentage,
                puzzlePadding: 5,
              )
            : GameBoardLayoutMedium(
                puzzleWidth: screenWidth * mediumScreenPercentage,
                puzzleHeight: screenWidth * mediumScreenPercentage,
                puzzlePadding: 5,
              ),
        web: (screenHeight < screenWidth)
            ? GameBoardLayoutLarge(
                puzzleWidth: screenHeight * largeScreenPercentage,
                puzzleHeight: screenHeight * largeScreenPercentage,
                puzzlePadding: 5,
              )
            : GameBoardLayoutLarge(
                puzzleWidth: screenWidth * largeScreenPercentage,
                puzzleHeight: screenWidth * largeScreenPercentage,
                puzzlePadding: 5,
              ));
  }
}

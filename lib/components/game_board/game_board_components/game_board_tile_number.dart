import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/bordered_text.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:provider/provider.dart';

class GameBoardTileNumber extends StatelessWidget {
  const GameBoardTileNumber({
    Key? key,
    required this.tileHeight,
    required this.tileWidth,
    required this.tile,
    // this.tileNumberOpacity = 1,
    this.textOpacityDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final double tileHeight;
  final double tileWidth;
  final Duration textOpacityDuration;
  final PuzzleTile tile;
  // final double tileNumberOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tileHeight / 2,
      width: tileWidth / 2,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Selector<PuzzleBoard, double>(
          selector: (_, puzzleBoard) => puzzleBoard.currentTileOpacity,
          builder: (context, tileNumberOpacity, child) => AnimatedOpacity(
            duration: textOpacityDuration,
            opacity: (tile.isBlankTile) ? 0 : tileNumberOpacity,
            child: child,
          ),
          child: BorderedText(
            text: (tile.tileNumber + 1).toString(),
            style: const TextStyle(fontFamily: 'JosefinSans'),
            textColor: Colors.white,
            strokeColor: Colors.black,
            strokeWidth: 3,
          ),
        ),
      ),
      // ),
    );
  }
}

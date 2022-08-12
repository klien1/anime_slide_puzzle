import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:provider/provider.dart';

class GameBoardTileNumber extends StatelessWidget {
  const GameBoardTileNumber({
    Key? key,
    required this.tileHeight,
    required this.tileWidth,
    required this.tile,
    this.textOpacityDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final double tileHeight;
  final double tileWidth;
  final Duration textOpacityDuration;
  final PuzzleTile tile;

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
          child: _BorderedText(
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

class _BorderedText extends StatelessWidget {
  const _BorderedText({
    Key? key,
    required this.text,
    required this.strokeWidth,
    required this.strokeColor,
    required this.textColor,
    this.style = const TextStyle(),
  }) : super(key: key);

  final String text;
  final double strokeWidth;
  final Color strokeColor;
  final Color textColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          style: style.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}

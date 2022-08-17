import 'package:anime_slide_puzzle/models/show_hints.dart';
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
    this.alwaysShow = false,
  }) : super(key: key);

  final double tileHeight;
  final double tileWidth;
  final Duration textOpacityDuration;
  final PuzzleTile tile;
  final bool alwaysShow;

  @override
  Widget build(BuildContext context) {
    bool showingHints = context.watch<ShowHints>().isShowingHints;

    return SizedBox(
      height: tileHeight / 2,
      width: tileWidth / 2,
      child: FittedBox(
        fit: BoxFit.contain,
        child: (alwaysShow)
            ? _BorderedText(
                text: (tile.tileNumber + 1).toString(),
                style: const TextStyle(fontFamily: 'JosefinSans'),
                textColor: Colors.white,
                strokeColor: Colors.black,
                strokeWidth: 3,
              )
            : AnimatedOpacity(
                duration: textOpacityDuration,
                opacity: (!showingHints || tile.isBlankTile) ? 0 : 1,
                child: _BorderedText(
                  key: UniqueKey(),
                  text: (tile.tileNumber + 1).toString(),
                  style: const TextStyle(fontFamily: 'JosefinSans'),
                  textColor: Colors.white,
                  strokeColor: Colors.black,
                  strokeWidth: 3,
                ),
              ),
      ),
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
        Text(text, style: style.copyWith(color: textColor)),
      ],
    );
  }
}

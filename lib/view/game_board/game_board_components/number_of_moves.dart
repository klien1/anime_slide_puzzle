import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberOfMoves extends StatelessWidget {
  const NumberOfMoves({
    Key? key,
    this.fontSize,
  }) : super(key: key);

  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${context.watch<PuzzleBoard>().numberOfMoves} Moves',
      style: TextStyle(fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }
}

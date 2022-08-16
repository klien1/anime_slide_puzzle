import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';

class SelectBoardSize extends StatelessWidget {
  const SelectBoardSize({
    Key? key,
    required this.minRowsOrColumns,
    required this.maxRowsOrColumns,
  }) : super(key: key);

  final int minRowsOrColumns;
  final int maxRowsOrColumns;

  @override
  Widget build(BuildContext context) {
    NumberPuzzleTiles selector = context.watch<NumberPuzzleTiles>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int numTiles = minRowsOrColumns;
            numTiles <= maxRowsOrColumns;
            ++numTiles)
          SizedBox(
            width: 60,
            child: ElevatedButton(
              onPressed: (context.read<PuzzleBoard>().isLookingForSolution)
                  ? null
                  : (selector.currentNumberOfTiles == numTiles)
                      ? null
                      : () => selector.changeNumberOfTiles(numTiles),
              child: Text('${numTiles}x$numTiles'),
            ),
          ),
      ],
    );
  }
}

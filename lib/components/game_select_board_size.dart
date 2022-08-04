import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';

const int maxNumberOfTiles = 4;

class SelectBoardSize extends StatelessWidget {
  const SelectBoardSize({Key? key}) : super(key: key);

  List<Widget> getNumberSelectorWidget(int numRowsOrCol, BuildContext context) {
    List<Widget> widgetList = [];
    NumberPuzzleTiles selector = context.watch<NumberPuzzleTiles>();

    for (int numTiles = 2; numTiles <= numRowsOrCol; ++numTiles) {
      widgetList.add(
        ElevatedButton(
          onPressed: (context.read<PuzzleBoard>().isLookingForSolution)
              ? null
              : (selector.currentNumberOfTiles == numTiles)
                  ? null
                  : () => selector.changeNumberOfTiles(numTiles),
          child: Text(numTiles.toString()),
        ),
      );
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getNumberSelectorWidget(maxNumberOfTiles, context));
  }
}

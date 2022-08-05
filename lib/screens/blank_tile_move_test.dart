import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/blank_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class BlankTileTest extends StatelessWidget {
  const BlankTileTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('rebuilding buttons');
    BlankTileController blankTileController =
        BlankTileController(puzzleBoard: context.watch<PuzzleBoard>());
    return Row(
      children: [
        TextButton(
          onPressed: () {
            blankTileController.moveBlankTile(Direction.left);
          },
          child: Text('move left'),
        ),
        TextButton(
          onPressed: () {
            blankTileController.moveBlankTile(Direction.right);
          },
          child: Text('move right'),
        ),
        TextButton(
          onPressed: () {
            blankTileController.moveBlankTile(Direction.top);
          },
          child: Text('move up'),
        ),
        TextButton(
          onPressed: () {
            blankTileController.moveNumberTileDirection(5, Direction.bottom);
          },
          child: Text('move 5 down'),
        ),
        TextButton(
          onPressed: () {
            blankTileController.moveList();
            // blankTileController.moveTileToCorrectPosition();
            // blankTileController.moveNumberTileDirection(0, Direction.left);
          },
          child: Text('move to target'),
        ),
      ],
    );
  }
}

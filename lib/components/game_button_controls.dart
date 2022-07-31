import 'package:anime_slide_puzzle/models/tile_number_opacity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            context.read<PuzzleBoard>().shuffleBoard();
          },
          child: Text('Random'),
        ),
        TextButton(
          onPressed: () {
            context.read<PuzzleBoard>().resetBoard();
          },
          child: Text('Solve not yet implemented'),
        ),
        TextButton(
          onPressed: () {
            context.read<TileNumberOpacity>().toggleShowNumber();
          },
          child: Text('Show numbers'),
        ),
      ],
    );
  }
}

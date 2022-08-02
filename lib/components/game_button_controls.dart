import 'dart:async';

import 'package:anime_slide_puzzle/components/game_status.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'dart:collection';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  // void solvePuzzle(BuildContext context) {
  //   List<List<int>> board = context.read<PuzzleBoard>().puzzleTileNumberMatrix;
  //   PuzzleSolver solver = PuzzleSolver(startingBoardState: board);

  //   Queue<Coordinate> moveList = solver.solvePuzzle();
  //   while (moveList.isNotEmpty) {
  //     Coordinate curMove = moveList.removeFirst();
  //     Coordinate nextMove = convert1dArrayCoordTo2dArrayCoord(
  //         index: board[curMove.row][curMove.col],
  //         numRowOrColCount: board.length);

  //     Timer(
  //         Duration(seconds: 1),
  //         () => context
  //             .read<PuzzleBoard>()
  //             .moveTile(clickedTileCoordinate: nextMove));
  //   }
  //   // print(solver.solvePuzzle());
  // }

  @override
  Widget build(BuildContext context) {
    PuzzleBoard curPuzzleBoardContext = context.read<PuzzleBoard>();

    return Column(
      children: [
        GameStatus(),
        TextButton(
          onPressed: () {
            curPuzzleBoardContext.startGame();
          },
          child: (context.watch<PuzzleBoard>().isGameInProgress)
              ? Text('Restart Game')
              : Text('Start Game'),
        ),
        TextButton(
          onPressed: () {
            // solvePuzzle(context);
            // context.read<PuzzleBoard>().resetBoard();
            // context.read<PuzzleBoard>().solvePuzzleWithAStar();
          },
          child: Text('Solve not yet implemented'),
        ),
        TextButton(
          onPressed: () {
            curPuzzleBoardContext.toggleTileNumberVisibility();
          },
          child: Text('Toggle Puzzle Number'),
        ),
      ],
    );
  }
}

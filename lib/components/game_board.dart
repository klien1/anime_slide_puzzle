import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int boardSize = 3;

class GameBoard extends StatelessWidget {
  GameBoard({Key? key}) : super(key: key);

  // final puzzleBoard = PuzzleBoard(boardSize).puzzleBoard;

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();

    return Center(
      child: Container(
        color: Colors.grey,
        height: 500,
        width: 500,
        child: GridView.count(
          clipBehavior: Clip.none,
          crossAxisCount: boardSize,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: [
            for (PuzzleTile tile in puzzleBoardProvider.puzzleBoard)

              // alignment
              // x = x * (w/2) + w/2
              // y = y * (h/2) + h/2
              // AnimatedAlign(
              //   alignment: Alignment(
              //     tile.currentCoordinate.x.toDouble(),
              //     tile.currentCoordinate.y.toDouble(),
              //   ),
              Container(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<PuzzleBoard>().moveLeft(tile.correctIndex),
                  child: AnimatedSlide(
                    offset: Offset(
                      tile.currentCoordinate.x.toDouble(),
                      tile.currentCoordinate.y.toDouble(),
                    ),
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.amber,
                      child: Center(
                        child: Text(
                          tile.tileText,
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

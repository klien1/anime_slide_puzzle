import 'dart:collection';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/auto_solver.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/puzzle_solver_helper.dart';

void main() {
  test('getTotalManhattanDistance should be 5', () {
    const boardState = [3, 0, 2, 8, 1, 4, 6, 7, 5];
    expect(
        calcTotalManhattanDistance(boardState: boardState, numRowsOrColumns: 3),
        5);
  });

  test('getTotalManhattanDistance should be 4', () {
    const boardState = [8, 0, 2, 3, 1, 4, 6, 7, 5];
    expect(
        calcTotalManhattanDistance(boardState: boardState, numRowsOrColumns: 3),
        4);
  });

  test('getTotalManhattanDistance should be 38', () {
    const boardState = [6, 9, 0, 13, 5, 1, 8, 3, 2, 10, 15, 4, 7, 11, 12, 14];
    expect(
        calcTotalManhattanDistance(boardState: boardState, numRowsOrColumns: 4),
        38);
  });

  test('getTotalManhattanDistance should be 0', () {
    const boardState = [0, 1, 2, 3, 4, 5, 6, 7, 8];

    expect(
        calcTotalManhattanDistance(boardState: boardState, numRowsOrColumns: 3),
        0);
  });

  test('getManhattanDistance should be 0 for (2,2) and (2,2)', () {
    const coord = Coordinate(row: 2, col: 2);

    expect(calcManhattanDist(first: coord, second: coord), 0);
  });

  test('getManhattanDistance should be 4 for (0,0) and (2,2)', () {
    const startCoord = Coordinate(row: 0, col: 0);
    const endCoord = Coordinate(row: 2, col: 2);
    expect(calcManhattanDist(first: startCoord, second: endCoord), 4);
  });

  test('IDAStarPuzzlerSolver should solve with 0 moves', () {
    const boardState = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    Queue<Coordinate> moveList = Queue();
    final IDAStarPuzzleSolver solver = IDAStarPuzzleSolver(
      initialBoardState: boardState,
      numRowsOrColumns: 3,
      blankTileCoordinate: const Coordinate(row: 2, col: 2),
    );
    expect(solver.solvePuzzle(), moveList);
  });

  test('IDAStarPuzzleSolver should take 1 step to reach goal state', () {
    const boardState = [0, 1, 2, 3, 4, 5, 6, 8, 7];

    Queue<Coordinate> moveList = Queue();
    moveList.addFirst(const Coordinate(row: 2, col: 2));

    final IDAStarPuzzleSolver solver = IDAStarPuzzleSolver(
      initialBoardState: boardState,
      numRowsOrColumns: 3,
      blankTileCoordinate: const Coordinate(row: 2, col: 1),
    );

    expect(solver.solvePuzzle(), moveList);
  });

  test('IDAStarPuzzleSolver should take 4 steps to reach goal state', () {
    const boardState = [8, 0, 2, 3, 1, 5, 6, 4, 7];

    Queue<Coordinate> moveList = Queue();
    moveList.addFirst(const Coordinate(row: 2, col: 2));
    moveList.addFirst(const Coordinate(row: 2, col: 1));
    moveList.addFirst(const Coordinate(row: 1, col: 1));
    moveList.addFirst(const Coordinate(row: 0, col: 1));

    final IDAStarPuzzleSolver solver = IDAStarPuzzleSolver(
      initialBoardState: boardState,
      numRowsOrColumns: 3,
      blankTileCoordinate: const Coordinate(row: 0, col: 0),
    );

    expect(solver.solvePuzzle(), moveList);
  });

  test('4x4 solver should return puzzle in original order', () {
    const boardState = [
      [1, 14, 13, 4],
      [10, 9, 7, 3],
      [2, 11, 6, 0],
      [8, 15, 12, 5]
    ];

    const original = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15]
    ];
    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: boardState);
    AutoSolver(puzzleBoard: puzzleBoard).solve();

    expect(puzzleBoard.curPositionMatrix, original);
  });

  test('5x5 solver should return puzzle in original order', () {
    const boardState = [
      [7, 23, 8, 6, 17],
      [22, 2, 1, 14, 11],
      [19, 3, 16, 5, 10],
      [20, 12, 24, 9, 15],
      [13, 4, 21, 18, 0]
    ];

    const original = [
      [0, 1, 2, 3, 4],
      [5, 6, 7, 8, 9],
      [10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24]
    ];
    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: boardState);
    AutoSolver(puzzleBoard: puzzleBoard).solve();

    expect(puzzleBoard.curPositionMatrix, original);
  });
}

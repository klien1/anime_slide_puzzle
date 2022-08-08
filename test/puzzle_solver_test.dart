import 'dart:collection';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';

void main() {
  test('getTotalManhattanDistance should be 5', () {
    const boardState = [3, 0, 2, 8, 1, 4, 6, 7, 5];
    expect(
        getTotalManhattanDistance(
          boardState: boardState,
          numRowsOrColumns: 3,
        ),
        5);
  });

  test('getTotalManhattanDistance should be 4', () {
    const boardState = [8, 0, 2, 3, 1, 4, 6, 7, 5];
    expect(
        getTotalManhattanDistance(
          boardState: boardState,
          numRowsOrColumns: 3,
        ),
        4);
  });

  test('getTotalManhattanDistance should be 38', () {
    const boardState = [6, 9, 0, 13, 5, 1, 8, 3, 2, 10, 15, 4, 7, 11, 12, 14];
    expect(
        getTotalManhattanDistance(
          boardState: boardState,
          numRowsOrColumns: 4,
        ),
        38);
  });

  test('getTotalManhattanDistance should be 0', () {
    const boardState = [0, 1, 2, 3, 4, 5, 6, 7, 8];

    expect(
        getTotalManhattanDistance(
          boardState: boardState,
          numRowsOrColumns: 3,
        ),
        0);
  });

  test('getManhattanDistance should be 0 for (2,2) and (2,2)', () {
    const coord = Coordinate(row: 2, col: 2);

    expect(getManhattanDistance(first: coord, second: coord), 0);
  });

  test('getManhattanDistance should be 4 for (0,0) and (2,2)', () {
    const startCoord = Coordinate(row: 0, col: 0);
    const endCoord = Coordinate(row: 2, col: 2);
    expect(getManhattanDistance(first: startCoord, second: endCoord), 4);
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
}

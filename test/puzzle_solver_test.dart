import 'dart:collection';
import 'package:anime_slide_puzzle/models/puzzleSolver/a_star_node.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Total Manhattan distance should be 5', () {
    const boardState = [
      [3, 0, 2],
      [8, 1, 4],
      [6, 7, 5]
    ];
    expect(AStarNode.getTotalManhattanDistance(boardState), 5);
  });

  test('Total Manhattan distance should be 4', () {
    const boardState = [
      [8, 0, 2],
      [3, 1, 4],
      [6, 7, 5]
    ];
    expect(AStarNode.getTotalManhattanDistance(boardState), 4);
  });

  test('Total Manhattan distance should be 0', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];

    expect(AStarNode.getTotalManhattanDistance(boardState), 0);
  });

  test('Manhattan distance should be 0', () {
    const coord = Coordinate(row: 2, col: 2);

    expect(AStarNode.getManhattanDistance(coord, coord), 0);
  });

  test('Manhattan distance should be 4', () {
    const startCoord = Coordinate(row: 0, col: 0);
    const endCoord = Coordinate(row: 2, col: 2);
    expect(AStarNode.getManhattanDistance(startCoord, endCoord), 4);
  });

  test('goal state should be in order', () {
    const boardState = [
      [3, 0, 2],
      [8, 1, 4],
      [6, 7, 5]
    ];
    final PuzzleSolver solver = PuzzleSolver(startingBoardState: boardState);
    expect(solver.generateGoalState(), [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]);
  });

  test('number of moves should be 0', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];
    Queue<Coordinate> moveList = Queue();
    final PuzzleSolver solver = PuzzleSolver(startingBoardState: boardState);
    expect(solver.solvePuzzle(), moveList);
  });

  test('AStarNode should be the same', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];

    const boardState2 = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];
    AStarNode first = AStarNode(boardState: boardState);
    AStarNode second = AStarNode(boardState: boardState2);
    expect(first == second, true);
  });

  test('AStarNode should be different', () {
    const boardState = [
      [3, 0, 2],
      [8, 1, 5],
      [6, 4, 7]
    ];

    const boardState2 = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];

    AStarNode first = AStarNode(boardState: boardState);
    AStarNode second = AStarNode(boardState: boardState2);
    expect(first == second, false);
  });

  test('1 step to reach goal state', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 8, 7]
    ];

    Queue<Coordinate> moveList = Queue();
    moveList.addFirst(const Coordinate(row: 2, col: 2));

    final PuzzleSolver solver = PuzzleSolver(startingBoardState: boardState);

    expect(solver.solvePuzzle(), moveList);
  });

  test('4 step to reach goal state', () {
    const boardState = [
      [8, 0, 2],
      [3, 1, 5],
      [6, 4, 7]
    ];

    Queue<Coordinate> moveList = Queue();
    moveList.addFirst(const Coordinate(row: 2, col: 2));
    moveList.addFirst(const Coordinate(row: 2, col: 1));
    moveList.addFirst(const Coordinate(row: 1, col: 1));
    moveList.addFirst(const Coordinate(row: 0, col: 1));

    final PuzzleSolver solver = PuzzleSolver(startingBoardState: boardState);

    expect(solver.solvePuzzle(), moveList);
  });
}

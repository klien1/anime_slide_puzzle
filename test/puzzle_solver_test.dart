import 'dart:collection';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/puzzle_solver/a_star_node.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/a_star_puzzle_solver.dart';
import 'package:anime_slide_puzzle/puzzle_solver/blank_tile_controller.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';

void main() {
  test('getTotalManhattanDistance should be 5', () {
    const boardState = [
      [3, 0, 2],
      [8, 1, 4],
      [6, 7, 5]
    ];
    expect(getTotalManhattanDistance(boardState), 5);
  });

  test('getTotalManhattanDistance should be 4', () {
    const boardState = [
      [8, 0, 2],
      [3, 1, 4],
      [6, 7, 5]
    ];
    expect(getTotalManhattanDistance(boardState), 4);
  });

  test('getTotalManhattanDistance should be 38', () {
    const boardState = [
      [6, 9, 0, 13],
      [5, 1, 8, 3],
      [2, 10, 15, 4],
      [7, 11, 12, 14]
    ];
    expect(getTotalManhattanDistance(boardState), 38);
  });

  test('getTotalManhattanDistance should be 0', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];

    expect(getTotalManhattanDistance(boardState), 0);
  });

  test('getTotalManhattanDistance1d should be 5', () {
    const List<int> boardState = [3, 0, 2, 8, 1, 4, 6, 7, 5];
    expect(getTotalManhattanDistance1d(boardState, 3), 5);
  });

  test('getTotalManhattanDistance1d should be 4', () {
    const boardState = [8, 0, 2, 3, 1, 4, 6, 7, 5];
    expect(getTotalManhattanDistance1d(boardState, 3), 4);
  });

  test('getTotalManhattanDistance1d should be 38', () {
    const boardState = [6, 9, 0, 13, 5, 1, 8, 3, 2, 10, 15, 4, 7, 11, 12, 14];
    expect(getTotalManhattanDistance1d(boardState, 4), 38);
  });

  test('getTotalManhattanDistance1d should be 0', () {
    const boardState = [0, 1, 2, 3, 4, 5, 6, 7, 8];

    expect(getTotalManhattanDistance1d(boardState, 3), 0);
  });

  test('getManhattanDistance should be 0 for (2,2) and (2,2)', () {
    const coord = Coordinate(row: 2, col: 2);

    expect(getManhattanDistance(coord, coord), 0);
  });

  test('getManhattanDistance should be 4 for (0,0) and (2,2)', () {
    const startCoord = Coordinate(row: 0, col: 0);
    const endCoord = Coordinate(row: 2, col: 2);
    expect(getManhattanDistance(startCoord, endCoord), 4);
  });

  test('generateGoalState for 2x2 should be\n[0, 1]\n[2, 3]', () {
    expect(generateGoalState(2), [
      [0, 1],
      [2, 3],
    ]);
  });

  test('generateGoalState for 3x3 should be\n[0, 1, 2]\n[3,4,5]\n[6,7,8]', () {
    expect(generateGoalState(3), [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]);
  });

  test(
      'generateGoalState for 4x4 should be\n[0, 1, 2, 3]\n[4, 5, 6, 7]\n[8, 9, 10, 11]\n[12, 13, 14, 15]',
      () {
    expect(generateGoalState(4), [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15]
    ]);
  });

  test('AStarNodes should be the same(==)', () {
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
    AStarNode first = AStarNode(
      initialBoardState: boardState,
      blankTileCoordinate: const Coordinate(
        row: 2,
        col: 2,
      ),
    );
    AStarNode second = AStarNode(
      initialBoardState: boardState2,
      blankTileCoordinate: const Coordinate(
        row: 2,
        col: 2,
      ),
    );
    expect(first == second, true);
  });

  test('AStarNodes should be different(!=)', () {
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

    AStarNode first = AStarNode(
      initialBoardState: boardState,
      blankTileCoordinate: const Coordinate(
        row: 1,
        col: 0,
      ),
    );
    AStarNode second = AStarNode(
      initialBoardState: boardState2,
      blankTileCoordinate: const Coordinate(
        row: 2,
        col: 2,
      ),
    );
    expect(first == second, false);
  });

  test('AStarPuzzlerSolver should solve with 0 moves', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];
    Queue<Coordinate> moveList = Queue();
    final AStarPuzzleSolver solver = AStarPuzzleSolver(
      startingBoardState: boardState,
      currentBlankTileCoordiante: const Coordinate(row: 2, col: 2),
    );
    expect(solver.solvePuzzle(const Coordinate(row: 2, col: 2)), moveList);
  });

  test('AStarPuzzleSolver should take 1 step to reach goal state', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 8, 7]
    ];

    Queue<Coordinate> moveList = Queue();
    moveList.addFirst(const Coordinate(row: 2, col: 2));

    final AStarPuzzleSolver solver = AStarPuzzleSolver(
      startingBoardState: boardState,
      currentBlankTileCoordiante: const Coordinate(row: 2, col: 1),
    );

    expect(solver.solvePuzzle(const Coordinate(row: 2, col: 1)), moveList);
  });

  test('AStarPuzzleSolver should take 4 steps to reach goal state', () {
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

    final AStarPuzzleSolver solver = AStarPuzzleSolver(
      startingBoardState: boardState,
      currentBlankTileCoordiante: const Coordinate(row: 0, col: 0),
    );

    expect(solver.solvePuzzle(const Coordinate(row: 0, col: 0)), moveList);
  });

  test('isSameMatrix should return true', () {
    const boardState = [
      [8, 0, 2],
      [3, 1, 5],
      [6, 4, 7]
    ];

    const boardState2 = [
      [8, 0, 2],
      [3, 1, 5],
      [6, 4, 7]
    ];

    expect(isSameMatrix(boardState, boardState2), true);
  });
  test('isSameMatrix should return false', () {
    const boardState = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];
    const boardState2 = [
      [8, 0, 2],
      [3, 1, 5],
      [6, 4, 7]
    ];
    expect(isSameMatrix(boardState, boardState2), false);
  });

  test('countTotalLinearConflicts should be 4', () {
    const List<List<int>> matrix = [
      [3, 1, 4],
      [0, 8, 5],
      [2, 7, 6]
    ];
    expect(countTotalLinearConflicts(matrix), 4);
  });

  test('countTotalLinearConflicts should be 4 again', () {
    const List<List<int>> matrix = [
      [8, 1, 0],
      [4, 3, 2],
      [5, 6, 7]
    ];
    expect(countTotalLinearConflicts(matrix), 4);
  });

  test('countTotalLinearConflicts should be 2', () {
    const List<List<int>> matrix = [
      [1, 6, 8],
      [4, 3, 2],
      [7, 0, 5]
    ];
    expect(countTotalLinearConflicts(matrix), 2);
  });

  test('countTotalLinearConflicts should be 0', () {
    const List<List<int>> matrix = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ];
    expect(countTotalLinearConflicts(matrix), 0);
  });

  test('countTotalLinearConflicts1d should be 4', () {
    const List<int> matrix = [3, 1, 4, 0, 8, 5, 2, 7, 6];
    expect(countTotalLinearConflicts1d(matrix, 3), 4);
  });

  test('countTotalLinearConflicts1d should be 4 again', () {
    const List<int> matrix = [8, 1, 0, 4, 3, 2, 5, 6, 7];
    expect(countTotalLinearConflicts1d(matrix, 3), 4);
  });

  test('countTotalLinearConflicts1d should be 2', () {
    const List<int> matrix = [1, 6, 8, 4, 3, 2, 7, 0, 5];
    expect(countTotalLinearConflicts1d(matrix, 3), 2);
  });

  test('countTotalLinearConflicts should be 0', () {
    const List<int> matrix = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    expect(countTotalLinearConflicts1d(matrix, 3), 0);
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

  // test('Blank tile controller should move 3 one space right', () {
  //   List<List<int>> matrix = [
  //     [0, 1, 2],
  //     [3, 4, 5],
  //     [6, 7, 8]
  //   ];

  //   const List<List<int>> resultMatrix = [
  //     [0, 1, 2],
  //     [4, 3, 5],
  //     [6, 7, 8]
  //   ];

  //   PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: matrix);
  //   BlankTileController blankTileController =
  //       BlankTileController(puzzleBoard: puzzleBoard);
  //   blankTileController.moveNumberTileDirection(3, Direction.right);

  //   expect(puzzleBoard.puzzleTileNumberMatrix, resultMatrix);
  // });
}

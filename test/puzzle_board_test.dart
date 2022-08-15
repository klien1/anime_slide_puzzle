import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

void main() {
  test('isPuzzleIsSolvable should return false', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];

    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: matrix);

    bool isSolvable = puzzleBoard.isPuzzleIsSolvable();
    expect(isSolvable, false);
  });
  test('isPuzzleIsSolvable should return true', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15]
    ];

    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: matrix);

    bool isSolvable = puzzleBoard.isPuzzleIsSolvable();
    expect(isSolvable, true);
  });

  group('successfully swapping tile position', () {
    List<List<int>> matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];

    const Coordinate first = Coordinate(row: 1, col: 1);
    const Coordinate second = Coordinate(row: 3, col: 3);

    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: matrix);

    bool succesfullySwapped =
        puzzleBoard.swapPosMatrix(first: first, second: second);

    test('position (1,1) and (3,3) should be swapped', () {
      expect(matrix, [
        [0, 1, 2, 3],
        [4, 15, 6, 7],
        [8, 9, 10, 11],
        [12, 14, 13, 5]
      ]);
    });

    test('matrix should have successfully swapped', () {
      expect(succesfullySwapped, true);
    });
  });

  group('failing to swapping tile position', () {
    List<List<int>> matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];

    PuzzleBoard puzzleBoard = PuzzleBoard.intBoard(board: matrix);

    const Coordinate first = Coordinate(row: -1, col: 1);
    const Coordinate second = Coordinate(row: 3, col: 3);
    bool failedToSwap = puzzleBoard.swapPosMatrix(first: first, second: second);

    test('position (-1,1) and (3,3) should not be swapped', () {
      expect(matrix, [
        [0, 1, 2, 3],
        [4, 5, 6, 7],
        [8, 9, 10, 11],
        [12, 14, 13, 15]
      ]);
    });

    test('matrix should have failed to swap', () {
      expect(failedToSwap, false);
    });
  });
}

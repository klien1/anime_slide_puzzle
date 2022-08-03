import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

void main() {
  test(
      '\n[0, 1, 2, 3],\n[4, 5, 15, 7],\n[8, 9, 6, 10],\n[12, 13, 14, 11]\ninversion count should return 6',
      () {
    List<List<int>> list = [
      [0, 1, 2, 3],
      [4, 5, 15, 7],
      [8, 9, 6, 10],
      [12, 13, 14, 11]
    ];

    expect(PuzzleBoard.countTotalInversion(matrix: list), 6);
  });

  test('\n[8, 0, 2],\n[3, 1, 4],\n[6, 7, 5]\ninversion count should return 4',
      () {
    List<List<int>> list = [
      [8, 0, 2],
      [3, 1, 4],
      [6, 7, 5]
    ];

    expect(PuzzleBoard.countTotalInversion(matrix: list), 4);
  });

  test(
      '\n[0, 1, 2, 3],\n[4, 5, 6, 7],\n[8, 9, 10, 11],\n[12, 13, 14, 15]\ninversion count should return 0',
      () {
    List<List<int>> list = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15]
    ];

    expect(PuzzleBoard.countTotalInversion(matrix: list), 0);
  });

  test('isPuzzleIsSolvable should return false', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];

    bool isSolvable =
        PuzzleBoard.isPuzzleIsSolvable(matrix: matrix, blankTileRow: 3);
    expect(isSolvable, false);
  });
  test('isPuzzleIsSolvable should return true', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15]
    ];

    bool isSolvable =
        PuzzleBoard.isPuzzleIsSolvable(matrix: matrix, blankTileRow: 3);
    expect(isSolvable, true);
  });

  test('isOutOfBounds should return true (0,-1)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          const Coordinate(row: 0, col: -1),
        ),
        true);
  });
  test('isOutOfBounds should return true (0,4)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          const Coordinate(row: 0, col: 4),
        ),
        true);
  });
  test('isOutOfBounds should return true (-1,0)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          const Coordinate(row: -1, col: 0),
        ),
        true);
  });
  test('isOutOfBounds should return true(4,0)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          const Coordinate(row: 4, col: 0),
        ),
        true);
  });
  test('isOutOfBounds should return false (2,2)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          const Coordinate(row: 2, col: 2),
        ),
        false);
  });
  test('isOutOfBounds should return false (3,3)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        PuzzleBoard.isOutOfBounds(
          matrix,
          Coordinate(row: matrix.length - 1, col: matrix.length - 1),
        ),
        false);
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
    bool succesfullySwapped = PuzzleBoard.swapTileNumbers(
        matrix: matrix, first: first, second: second);

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

    const Coordinate first = Coordinate(row: -1, col: 1);
    const Coordinate second = Coordinate(row: 3, col: 3);
    bool failedToSwap = PuzzleBoard.swapTileNumbers(
        matrix: matrix, first: first, second: second);

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

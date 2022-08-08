import 'package:flutter_test/flutter_test.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';

void main() {
  test('tile number 11 should return (2,3)', () {
    Coordinate curCoord =
        convert1dArrayCoordTo2dArrayCoord(index: 11, numRowOrColCount: 4);
    expect(curCoord, const Coordinate(row: 2, col: 3));
  });

  test('(2,3) should return tile number 11', () {
    int val =
        convert2dArrayCoordTo1dArrayCoord(row: 2, col: 3, numRowOrColCount: 4);
    expect(val, 11);
  });

  test('isEven(8) should return true', () {
    expect(isEven(num: 8), true);
  });

  test('isEven(41) should return false', () {
    expect(isEven(num: 41), false);
  });

  test(
      '\n[0, 1, 2, 3],\n[4, 5, 15, 7],\n[8, 9, 6, 10],\n[12, 13, 14, 11]\ninversion count should return 6',
      () {
    List<List<int>> list = [
      [0, 1, 2, 3],
      [4, 5, 15, 7],
      [8, 9, 6, 10],
      [12, 13, 14, 11]
    ];

    expect(countTotalInversion(matrix: list), 6);
  });

  test('\n[8, 0, 2],\n[3, 1, 4],\n[6, 7, 5]\ninversion count should return 4',
      () {
    List<List<int>> list = [
      [8, 0, 2],
      [3, 1, 4],
      [6, 7, 5]
    ];

    expect(countTotalInversion(matrix: list), 4);
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

    expect(countTotalInversion(matrix: list), 0);
  });

  test('isOutOfBounds should return true (0,-1)', () {
    const matrix = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 14, 13, 15]
    ];
    expect(
        isOutOfBounds(
          matrix: matrix,
          curPoint: const Coordinate(row: 0, col: -1),
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
        isOutOfBounds(
          matrix: matrix,
          curPoint: const Coordinate(row: 0, col: 4),
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
        isOutOfBounds(
          matrix: matrix,
          curPoint: const Coordinate(row: -1, col: 0),
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
        isOutOfBounds(
          matrix: matrix,
          curPoint: const Coordinate(row: 4, col: 0),
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
        isOutOfBounds(
          matrix: matrix,
          curPoint: const Coordinate(row: 2, col: 2),
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
        isOutOfBounds(
          matrix: matrix,
          curPoint: Coordinate(row: matrix.length - 1, col: matrix.length - 1),
        ),
        false);
  });
}

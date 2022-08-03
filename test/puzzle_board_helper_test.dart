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
    expect(isEven(8), true);
  });

  test('isEven(41) should return false', () {
    expect(isEven(41), false);
  });
}

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
}

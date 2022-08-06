import 'package:anime_slide_puzzle/models/coordinate.dart';

Coordinate convert1dArrayCoordTo2dArrayCoord({
  required int index,
  required int numRowOrColCount,
}) {
  final int row = index ~/ numRowOrColCount;
  final int col = index % numRowOrColCount;
  return Coordinate(row: row, col: col);
}

int convert2dArrayCoordTo1dArrayCoord({
  required int row,
  required int col,
  required int numRowOrColCount,
}) {
  return row * numRowOrColCount + col;
}

bool isEven(int num) {
  return num % 2 == 0;
}

// Count # of inversions
// An inversion is any pair of tiles i and j where i < j
// but i appears after j when considering the board in row-major order
int countTotalInversion({required List<List<int>> matrix}) {
  int numRowsOrColumns = matrix.length;

  List<int> currentTilePosition1d = [];
  for (var element in matrix) {
    currentTilePosition1d.addAll(element);
  }

  return countInversion(
    currentTilePosition1d,
    numRowsOrColumns * numRowsOrColumns - 1,
  );
}

int countInversion(List<int> tileNumberList, int blankTileNum) {
  int numInversions = 0;

  for (int i = 0; i < tileNumberList.length; ++i) {
    final curVal = tileNumberList[i];
    for (int j = i + 1; j < tileNumberList.length; ++j) {
      // skip inversion count if blank tile
      if (curVal == blankTileNum) continue;

      if (curVal > tileNumberList[j]) ++numInversions;
    }
  }
  return numInversions;
}

bool isOutOfBounds(
  List<List<int>> matrix,
  Coordinate curPoint,
) {
  if (curPoint.row < 0 ||
      curPoint.col < 0 ||
      curPoint.row >= matrix.length ||
      curPoint.col >= matrix[curPoint.row].length) {
    return true;
  }
  return false;
}

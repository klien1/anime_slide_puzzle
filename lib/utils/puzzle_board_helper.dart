import 'package:anime_slide_puzzle/models/coordinate.dart';

Coordinate findCorrectTileCoordinate({
  required int index,
  required int numRowsOrColumns,
}) {
  final int row = index ~/ numRowsOrColumns;
  final int col = index % numRowsOrColumns;
  return Coordinate(row: row, col: col);
}

bool isEven({required int num}) {
  return num % 2 == 0;
}

// Count # of inversions
// An inversion is any pair of tiles i and j where i < j
// but i appears after j when considering the board in row-major order
int countTotalInversion({required List<List<int>> matrix}) {
  int numRowsOrColumns = matrix.length;

  List<int> currentTilePositions = [];
  for (var element in matrix) {
    currentTilePositions.addAll(element);
  }

  int numInversions = 0;
  final int blankTileNum = numRowsOrColumns * numRowsOrColumns - 1;

  for (int i = 0; i < currentTilePositions.length; ++i) {
    final curVal = currentTilePositions[i];
    for (int j = i + 1; j < currentTilePositions.length; ++j) {
      // skip inversion count if blank tile
      if (curVal == blankTileNum) continue;

      if (curVal > currentTilePositions[j]) ++numInversions;
    }
  }
  return numInversions;
}

bool isOutOfBoundsMatrix({
  required List<List<int>> matrix,
  required Coordinate curPoint,
}) {
  if (curPoint.row < 0 ||
      curPoint.col < 0 ||
      curPoint.row >= matrix.length ||
      curPoint.col >= matrix[curPoint.row].length) {
    return true;
  }
  return false;
}

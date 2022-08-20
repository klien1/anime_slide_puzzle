import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';

int calcTotalManhattanDistance({
  required List<int> boardState,
  required int numRowsOrColumns,
}) {
  int totalManhattanValue = 0;
  final blankTileNum = boardState.length - 1;

  for (int row = 0; row < numRowsOrColumns; ++row) {
    for (int col = 0; col < numRowsOrColumns; ++col) {
      final currentTileNumber = boardState[row * numRowsOrColumns + col];
      // skip blank tile
      if (currentTileNumber == blankTileNum) continue;

      Coordinate curCoord = Coordinate(row: row, col: col);

      totalManhattanValue += findManhattanDistanceWithTileNumber(
        tileNum: currentTileNumber,
        numRowsOrColumns: numRowsOrColumns,
        currentCoordinate: curCoord,
      );
    }
  }
  return totalManhattanValue;
}

int findManhattanDistanceWithTileNumber({
  required int tileNum,
  required int numRowsOrColumns,
  required Coordinate currentCoordinate,
}) {
  Coordinate correctCoord = findCorrectTileCoordinate(
    index: tileNum,
    numRowsOrColumns: numRowsOrColumns,
  );

  return calcManhattanDist(first: correctCoord, second: currentCoordinate);
}

int calcManhattanDist({required Coordinate first, required Coordinate second}) {
  return (first.col - second.col).abs() + (first.row - second.row).abs();
}

List<int> generateGoalState({required int numRowsOrColumns}) {
  return List.generate(
    numRowsOrColumns * numRowsOrColumns,
    (index) => index,
    growable: false,
  );
}

bool swap1dMatrix({
  required List<int> matrix1d,
  required int numRowOrColumn,
  required Coordinate first,
  required Coordinate second,
}) {
  if (isOutOfBounds1d(length: numRowOrColumn, curPoint: first) ||
      isOutOfBounds1d(length: numRowOrColumn, curPoint: second)) return false;

  // both points are within boundary
  int firstPoint = first.getOneDimensionalArrayIndex(numRowOrColumn);
  int secondPoint = second.getOneDimensionalArrayIndex(numRowOrColumn);

  int temp = matrix1d[firstPoint];
  matrix1d[firstPoint] = matrix1d[secondPoint];
  matrix1d[secondPoint] = temp;

  return true;
}

bool isOutOfBounds1d({
  required int length,
  required Coordinate curPoint,
}) {
  if (curPoint.row < 0 ||
      curPoint.col < 0 ||
      curPoint.row >= length ||
      curPoint.col >= length) return true;
  return false;
}

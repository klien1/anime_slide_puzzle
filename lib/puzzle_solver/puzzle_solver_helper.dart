import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:collection/collection.dart';

int getTotalManhattanDistance({
  required List<int> boardState,
  required int numRowsOrColumns,
}) {
  int totalManhattanValue = 0;
  final blankTileNum = boardState.length - 1;

  for (int row = 0; row < numRowsOrColumns; ++row) {
    for (int col = 0; col < numRowsOrColumns; ++col) {
      final curTileNum = boardState[row * numRowsOrColumns + col];
      // skip blank tile
      if (curTileNum == blankTileNum) continue;

      Coordinate curCoord = Coordinate(
        row: row,
        col: col,
      );

      totalManhattanValue += findManhattanDistanceWithTileNumber(
        tileNum: curTileNum,
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
  Coordinate correctCoord = convert1dArrayCoordTo2dArrayCoord(
    index: tileNum,
    numRowOrColCount: numRowsOrColumns,
  );

  Coordinate curCoord = Coordinate(
    row: currentCoordinate.row,
    col: currentCoordinate.col,
  );

  return getManhattanDistance(correctCoord, curCoord);
}

int getManhattanDistance(Coordinate first, Coordinate second) {
  return (first.col - second.col).abs() + (first.row - second.row).abs();
}

List<int> generateGoalState(int numRowsOrColumns) {
  return List.generate(
    numRowsOrColumns * numRowsOrColumns,
    (index) => index,
    growable: false,
  );
}

bool isSameMatrix(List<List<int>> first, List<List<int>> second) {
  return const DeepCollectionEquality().equals(first, second);
}

bool swap1dMatrix(
  List<int> matrix1d,
  int numRowOrColumn,
  Coordinate first,
  Coordinate second,
) {
  if (isOutOfBounds1d(numRowOrColumn, first) ||
      isOutOfBounds1d(numRowOrColumn, second)) return false;
  // both points are within boundary

  int firstPoint = convert2dArrayCoordTo1dArrayCoord(
    row: first.row,
    col: first.col,
    numRowOrColCount: numRowOrColumn,
  );
  int secondPoint = convert2dArrayCoordTo1dArrayCoord(
    row: second.row,
    col: second.col,
    numRowOrColCount: numRowOrColumn,
  );

  int temp = matrix1d[firstPoint];
  matrix1d[firstPoint] = matrix1d[secondPoint];
  matrix1d[secondPoint] = temp;

  return true;
}

bool isOutOfBounds1d(int length, Coordinate curPoint) {
  if (curPoint.row < 0 ||
      curPoint.col < 0 ||
      curPoint.row >= length ||
      curPoint.col >= length) return true;
  return false;
}

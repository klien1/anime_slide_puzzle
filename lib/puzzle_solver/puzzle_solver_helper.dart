import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:collection/collection.dart';

enum Axis { row, col }

int countTotalLinearConflicts(List<List<int>> matrix) {
  // for each row
  int totalLinearConflicts = 0;
  for (int row = 0; row < matrix.length; ++row) {
    totalLinearConflicts += countLinearConflicts(matrix[row], row, Axis.row);
  }

  // for each col
  for (int row = 0; row < matrix.length; ++row) {
    List<int> colList = List.filled(matrix[row].length, 0);
    for (int col = 0; col < matrix[row].length; ++col) {
      colList[col] = matrix[col][row];
    }
    totalLinearConflicts += countLinearConflicts(colList, row, Axis.col);
  }
  return totalLinearConflicts * 2;
}

int countTotalLinearConflicts1d(List<int> matrix, int numRowOrColumn) {
  // for each row
  int totalLinearConflicts = 0;
  for (int row = 0; row < numRowOrColumn; ++row) {
    List<int> rowList = List.filled(numRowOrColumn, 0);
    for (int col = 0; col < numRowOrColumn; ++col) {
      rowList[col] = matrix[row * numRowOrColumn + col];
    }
    totalLinearConflicts += countLinearConflicts(rowList, row, Axis.row);
  }

  // for each col
  for (int row = 0; row < numRowOrColumn; ++row) {
    List<int> colList = List.filled(numRowOrColumn, 0);
    for (int col = 0; col < numRowOrColumn; ++col) {
      colList[col] = matrix[col * numRowOrColumn + row];
    }
    totalLinearConflicts += countLinearConflicts(colList, row, Axis.col);
  }
  return totalLinearConflicts * 2;
}

int countLinearConflicts(List<int> tileNumList, int index, Axis axis) {
  int numLinearConflicts = 0;
  int emptyTileNum = tileNumList.length * tileNumList.length - 1;

  // create list to keep track if tiles are in correct position
  List<bool> isInCorrectPosition = List.filled(tileNumList.length, false);
  for (int i = 0; i < tileNumList.length; ++i) {
    isInCorrectPosition[i] = isCorrectIndex(
      tileNumList[i],
      index,
      tileNumList.length,
      axis,
    );
  }

  for (int i = 0; i < tileNumList.length; ++i) {
    // do not need to consider tiles in wrong row/col or blank tile
    final int curNum = tileNumList[i];
    if (!isInCorrectPosition[i] || curNum == emptyTileNum) continue;
    for (int j = i + 1; j < tileNumList.length; ++j) {
      final int otherNum = tileNumList[j];
      if (!isInCorrectPosition[j] || otherNum == emptyTileNum) continue;
      if (curNum > otherNum) ++numLinearConflicts;
    }
  }
  return numLinearConflicts;
}

/// @return true if tile is in correct row or column
///
/// @param num = tile number
/// @param index = index of row or col for current tile position
/// @param matrixLength = dimension of puzzle
/// @param axis = tells function to compare row or column
///
bool isCorrectIndex(int num, int index, int matrixLength, Axis axis) {
  Coordinate correctPos = convert1dArrayCoordTo2dArrayCoord(
    index: num,
    numRowOrColCount: matrixLength,
  );
  return (axis == Axis.row) ? correctPos.row == index : correctPos.col == index;
}

int getTotalManhattanDistance(List<List<int>> boardState) {
  int totalManhattanValue = 0;

  for (int row = 0; row < boardState.length; ++row) {
    for (int col = 0; col < boardState[row].length; ++col) {
      final blankTileNum = boardState.length * boardState.length - 1;
      if (boardState[row][col] == blankTileNum) continue;

      Coordinate correctCoord = convert1dArrayCoordTo2dArrayCoord(
        index: boardState[row][col],
        numRowOrColCount: boardState.length,
      );
      totalManhattanValue +=
          getManhattanDistance(correctCoord, Coordinate(row: row, col: col));
    }
  }
  return totalManhattanValue;
}

int getTotalManhattanDistance1d(List<int> boardState, int numRowOrColumns) {
  int totalManhattanValue = 0;
  final blankTileNum = boardState.length - 1;

  for (int row = 0; row < numRowOrColumns; ++row) {
    for (int col = 0; col < numRowOrColumns; ++col) {
      final curTileNum = boardState[row * numRowOrColumns + col];
      // skip blank tile
      if (curTileNum == blankTileNum) continue;

      Coordinate curCoord = Coordinate(
        row: row,
        col: col,
      );

      totalManhattanValue += getManhattanDistance1d(
        tileNum: curTileNum,
        numRowOrColumn: numRowOrColumns,
        currentCoordinate: curCoord,
      );
    }
  }
  return totalManhattanValue;
}

int getManhattanDistance1d({
  required int tileNum,
  required int numRowOrColumn,
  required Coordinate currentCoordinate,
}) {
  Coordinate correctCoord = convert1dArrayCoordTo2dArrayCoord(
    index: tileNum,
    numRowOrColCount: numRowOrColumn,
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

List<List<int>> generateGoalState(int numRowsOrColumns) {
  return List.generate(
    numRowsOrColumns,
    (row) =>
        List.generate(numRowsOrColumns, (col) => row * numRowsOrColumns + col),
    growable: false,
  );
}

List<int> generateGoalState1d(int numRowsOrColumns) {
  return List.generate(
    numRowsOrColumns * numRowsOrColumns,
    (index) => index,
    growable: false,
  );
}

bool isSameMatrix(List<List<int>> first, List<List<int>> second) {
  return const DeepCollectionEquality().equals(first, second);
}

List<List<int>> copyBoardState(List<List<int>> boardState) {
  List<List<int>> newBoardState = [
    for (List<int> row in boardState) [...row]
  ];
  return newBoardState;
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

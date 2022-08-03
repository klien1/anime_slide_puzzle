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

int getManhattanDistance(Coordinate first, Coordinate second) {
  return (first.col - second.col).abs() + (first.row - second.row).abs();
}

List<List<int>> generateGoalState(int numRowsOrColumns) {
  return List.generate(
    numRowsOrColumns,
    (row) =>
        List.generate(numRowsOrColumns, (col) => row * numRowsOrColumns + col),
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

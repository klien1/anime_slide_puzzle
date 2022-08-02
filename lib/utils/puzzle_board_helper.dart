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

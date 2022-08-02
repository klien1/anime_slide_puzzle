import 'package:equatable/equatable.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';

class AStarNode extends Equatable {
  final List<List<int>> _boardState;
  final AStarNode? _prevBoardState;
  final int _curMove;
  late final double _heuristic;

  AStarNode({
    required List<List<int>> boardState,
    int curMove = 0,
    AStarNode? prevBoardState,
  })  : _boardState = boardState,
        _curMove = curMove,
        _prevBoardState = prevBoardState {
    _heuristic = (getTotalManhattanDistance(_boardState) + _curMove).toDouble();
  }

  static int getTotalManhattanDistance(List<List<int>> boardState) {
    int totalManhattanValue = 0;

    for (int row = 0; row < boardState.length; ++row) {
      for (int col = 0; col < boardState[row].length; ++col) {
        final blankTileNum = boardState.length * boardState.length - 1;
        if (boardState[row][col] == blankTileNum) continue;
        Coordinate correctCoord = convert1dArrayCoordTo2dArrayCoord(
            index: boardState[row][col], numRowOrColCount: boardState.length);
        totalManhattanValue +=
            getManhattanDistance(correctCoord, Coordinate(row: row, col: col));
      }
    }
    return totalManhattanValue;
  }

  static int getManhattanDistance(
      Coordinate firstCoord, Coordinate secondCoord) {
    return (firstCoord.col - secondCoord.col).abs() +
        (firstCoord.row - secondCoord.row).abs();
  }

  List<List<int>> get boardState {
    return _boardState;
  }

  AStarNode? get prevBoardState {
    return _prevBoardState;
  }

  int get curMove {
    return _curMove;
  }

  double get heuristic {
    return _heuristic;
  }

  Coordinate getBlankTileCoordiante() {
    for (int row = 0; row < _boardState.length; ++row) {
      for (int col = 0; col < _boardState[row].length; ++col) {
        final blankTileNum = _boardState.length * _boardState.length - 1;
        if (_boardState[row][col] == blankTileNum) {
          return Coordinate(row: row, col: col);
        }
      }
    }
    return const Coordinate(row: -1, col: -1);
  }

  @override
  List<List<int>> get props => _boardState;
}

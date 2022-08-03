import 'package:equatable/equatable.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';

class AStarNode extends Equatable {
  final List<List<int>> _initialBoardState;
  final AStarNode? _prevBoardState;
  final int _curMove;
  final Coordinate _blankTileCoordinate;
  late final double _heuristic;

  AStarNode({
    required List<List<int>> initialBoardState,
    Coordinate blankTileCoordinate = const Coordinate(row: 0, col: 0),
    int curMove = 0,
    AStarNode? prevBoardState,
  })  : _initialBoardState = initialBoardState,
        _curMove = curMove,
        _blankTileCoordinate = blankTileCoordinate,
        _prevBoardState = prevBoardState {
    _heuristic =
        (getTotalManhattanDistance(_initialBoardState) + _curMove).toDouble();
  }

  List<List<int>> get boardState {
    return _initialBoardState;
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

  Coordinate get getBlankTileCoordinate {
    return _blankTileCoordinate;
  }

  @override
  List<List<int>> get props => _initialBoardState;
}

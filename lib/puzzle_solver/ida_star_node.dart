import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';
import 'package:equatable/equatable.dart';

class IDAStarNode extends Equatable {
  final List<List<int>> _boardState;
  final int _numMoves;
  final Coordinate _blankTileCoordinate;
  late final double _fScore;

  IDAStarNode({
    required List<List<int>> boardState,
    required Coordinate blankTileCoordinate,
    required int numMoves,
    IDAStarNode? prevNode,
  })  : _boardState = boardState,
        _blankTileCoordinate = blankTileCoordinate,
        _numMoves = numMoves {
    _fScore = (numMoves +
            getTotalManhattanDistance(_boardState) +
            countTotalLinearConflicts(_boardState))
        .toDouble();
  }

  double get fScore {
    return _fScore;
  }

  int get numMoves {
    return _numMoves;
  }

  Coordinate get blankTileCoordiante {
    return _blankTileCoordinate;
  }

  List<List<int>> get boardState {
    return _boardState;
  }

  @override
  List<List<int>> get props => _boardState;
}

import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:equatable/equatable.dart';

class IDAStarNode extends Equatable {
  final List<int> _boardState;
  final int _numMoves;
  final Coordinate _blankTileCoordinate;
  final int _manhattanDistance;
  final double _fScore;

  const IDAStarNode({
    required List<int> boardState,
    required Coordinate blankTileCoordinate,
    required int numMoves,
    required int manhattanDistance,
    required double fScore,
  })  : _boardState = boardState,
        _blankTileCoordinate = blankTileCoordinate,
        _numMoves = numMoves,
        _manhattanDistance = manhattanDistance,
        _fScore = fScore;

  double get fScore {
    return _fScore;
  }

  int get numMoves {
    return _numMoves;
  }

  Coordinate get blankTileCoordiante {
    return _blankTileCoordinate;
  }

  List<int> get boardState {
    return _boardState;
  }

  int get manhattanDistance {
    return _manhattanDistance;
  }

  @override
  List<int> get props => _boardState;
}

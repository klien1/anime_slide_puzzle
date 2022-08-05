import 'dart:collection';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_node.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';
import 'package:collection/collection.dart';

class IDAStarPuzzleSolver {
  final List<int> _initialBoardState;
  final Coordinate _initialBlankTileCoordinate;
  final Function _isEquals = const ListEquality().equals;

  bool _didFindSolution = false;
  double _threshold = double.infinity;

  late final int _numRowsOrColumns;
  late final int _initialManhattanDistance;
  late final List<int> _goalState;

  IDAStarPuzzleSolver({
    required List<int> initialBoardState,
    required int numRowsOrColumns,
    required Coordinate blankTileCoordinate,
  })  : _initialBoardState = initialBoardState,
        _numRowsOrColumns = numRowsOrColumns,
        _initialBlankTileCoordinate = blankTileCoordinate {
    _goalState = generateGoalState1d(numRowsOrColumns);
    _initialManhattanDistance = getTotalManhattanDistance1d(
      _initialBoardState,
      numRowsOrColumns,
    );
  }

  Queue<Coordinate> solvePuzzle() {
    Queue<Coordinate> moveList = Queue();

    // already checked to see if puzzle is solvable when generating the board

    // exit method if puzzle cannot be solved
    // bool puzzleIsSolvable = PuzzleBoard.isPuzzleIsSolvable(
    //   matrix: _initialBoardState,
    //   blankTileRow: _initialBlankTileCoordinate.row,
    // );
    // if (!puzzleIsSolvable) moveList;

    // initialize values for solution
    IDAStarNode curNode = IDAStarNode(
        boardState: _initialBoardState,
        blankTileCoordinate: _initialBlankTileCoordinate,
        numMoves: 0,
        manhattanDistance: _initialManhattanDistance,
        fScore: _initialManhattanDistance.toDouble());
    _threshold = curNode.fScore;

    Queue<IDAStarNode> pathToCurrentNode = Queue();
    pathToCurrentNode.addFirst(curNode);

    while (!_didFindSolution) {
      _threshold = _search(pathToCurrentNode);
    }

    // found solution. adding move list to stack
    while (pathToCurrentNode.length > 1) {
      IDAStarNode curNode = pathToCurrentNode.removeFirst();
      moveList.addFirst(curNode.blankTileCoordiante);
    }
    return moveList;
  }

  double _search(Queue<IDAStarNode> path) {
    final IDAStarNode curNode = path.first;
    final double fScore = curNode.fScore;

    if (_isEquals(curNode.boardState, _goalState)) {
      _didFindSolution = true;
      return fScore;
    }
    if (fScore > _threshold) return fScore;

    double minThreshold = double.infinity;
    List<IDAStarNode> listOfValidAdjacentNodes = getValidAdjacentNodes(curNode);
    for (IDAStarNode adjNode in listOfValidAdjacentNodes) {
      // check if we have visited puzzle state
      if (!path.contains(adjNode)) {
        path.addFirst(adjNode);

        double currentThreshold = _search(path);
        if (_didFindSolution) return fScore;
        if (currentThreshold < minThreshold) minThreshold = currentThreshold;

        // remove node after visiting child nodes
        path.removeFirst();
      }
    }
    return minThreshold;
  }

  List<IDAStarNode> getValidAdjacentNodes(IDAStarNode curNode) {
    List<IDAStarNode> adjList = [];

    Coordinate curBlankTile = curNode.blankTileCoordiante;
    // down
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(direction: Direction.bottom),
      adjList,
    );
    // up
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(direction: Direction.top),
      adjList,
    );
    // right
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(direction: Direction.right),
      adjList,
    );
    // left
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(direction: Direction.left),
      adjList,
    );

    return adjList;
  }

  void _addNextBoardState(
    IDAStarNode curNode,
    Coordinate adjacentTileCoordinate,
    List<IDAStarNode> adjList,
  ) {
    // check if coordinates are within boundary
    if (isOutOfBounds1d(_numRowsOrColumns, adjacentTileCoordinate)) return;

    // copy board
    final List<int> newBoardState =
        List.of(curNode.boardState, growable: false);

    final tileNum = newBoardState[
        adjacentTileCoordinate.row * _numRowsOrColumns +
            adjacentTileCoordinate.col];

    final int prevManhattanValue = getManhattanDistance1d(
      tileNum: tileNum,
      numRowOrColumn: _numRowsOrColumns,
      currentCoordinate: adjacentTileCoordinate,
    );

    final bool didSwapPosition = swap1dMatrix(
      newBoardState,
      _numRowsOrColumns,
      curNode.blankTileCoordiante,
      adjacentTileCoordinate,
    );
    if (!didSwapPosition) return;

    // check if moving tile will increase or decrease manhattan distance
    // node swapped with blankNode
    final int newManhattanValue = getManhattanDistance1d(
      tileNum: tileNum,
      numRowOrColumn: _numRowsOrColumns,
      currentCoordinate: curNode.blankTileCoordiante,
    );

    final int newManhattanDistance =
        curNode.manhattanDistance + (newManhattanValue - prevManhattanValue);

    // calculate fScore
    final double fScore = newManhattanDistance +
        curNode.numMoves +
        1 +
        countTotalLinearConflicts1d(newBoardState, _numRowsOrColumns)
            .toDouble();

    IDAStarNode newNode = IDAStarNode(
      boardState: newBoardState,
      blankTileCoordinate: adjacentTileCoordinate,
      manhattanDistance: newManhattanDistance,
      numMoves: curNode.numMoves + 1,
      fScore: fScore,
    );

    adjList.add(newNode);
  }
}

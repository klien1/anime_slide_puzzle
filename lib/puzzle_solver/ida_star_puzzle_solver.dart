import 'dart:collection';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_node.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';

class IDAStarPuzzleSolver {
  final List<List<int>> _initialBoardState;
  final Coordinate _initialBlankTileCoordinate;
  late final IDAStarNode _goalState;
  bool _didFindSolution = false;
  double _threshold = double.infinity;
  late int _manhattanDistance;

  IDAStarPuzzleSolver({
    required List<List<int>> initialBoardState,
    required Coordinate blankTileCoordinate,
  })  : _initialBoardState = initialBoardState,
        _initialBlankTileCoordinate = blankTileCoordinate {
    _goalState = IDAStarNode(
      boardState: generateGoalState(initialBoardState.length),
      blankTileCoordinate: blankTileCoordinate,
      numMoves: 0,
    );
    _manhattanDistance = getTotalManhattanDistance(_initialBoardState);
  }

  Queue<Coordinate> solvePuzzle() {
    Queue<Coordinate> moveList = Queue();

    // checked to see if puzzle is solvable when generating the board

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
    );
    _threshold = curNode.fScore;

    Queue<IDAStarNode> pathToCurrentNode = Queue();
    pathToCurrentNode.addFirst(curNode);

    while (!_didFindSolution) {
      _threshold = _search(pathToCurrentNode);
    }

    while (pathToCurrentNode.length > 1) {
      IDAStarNode curNode = pathToCurrentNode.removeFirst();
      moveList.addFirst(curNode.blankTileCoordiante);
    }
    return moveList;
  }

  double _search(Queue<IDAStarNode> path) {
    final IDAStarNode curNode = path.first;
    final double fScore = curNode.fScore;

    if (curNode == _goalState) {
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
      curBlankTile.calculateAdjacent(row: 1),
      adjList,
    );
    // up
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(row: -1),
      adjList,
    );
    // right
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(col: 1),
      adjList,
    );
    // left
    _addNextBoardState(
      curNode,
      curBlankTile.calculateAdjacent(col: -1),
      adjList,
    );

    return adjList;
  }

  void _addNextBoardState(
    IDAStarNode curNode,
    Coordinate adjacentTileCoordinate,
    List<IDAStarNode> adjList,
  ) {
    // copy board
    List<List<int>> newBoardState = copyBoardState(curNode.boardState);

    bool didSwapPosition = PuzzleBoard.swapTileNumbers(
      matrix: newBoardState,
      first: curNode.blankTileCoordiante,
      second: adjacentTileCoordinate,
    );
    if (!didSwapPosition) return;

    IDAStarNode newNode = IDAStarNode(
      boardState: newBoardState,
      blankTileCoordinate: adjacentTileCoordinate,
      numMoves: curNode.numMoves + 1,
    );

    adjList.add(newNode);
  }
}

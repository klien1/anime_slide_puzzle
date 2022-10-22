import 'dart:math';

import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/puzzle_solver_helper.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'dart:collection';
import 'package:anime_slide_puzzle/constants.dart';

enum CornerCase { topRight, bottomLeft }

class AutoSolver {
  AutoSolver({required this.puzzleBoard});
  final PuzzleBoard puzzleBoard;
  final Queue<Direction> _clockwise = Queue.from([
    Direction.top,
    Direction.topRight,
    Direction.right,
    Direction.bottomRight,
    Direction.bottom,
    Direction.bottomLeft,
    Direction.left,
    Direction.topLeft,
  ]);
  final Queue<Direction> _counterclockwise = Queue.from([
    Direction.top,
    Direction.topLeft,
    Direction.left,
    Direction.bottomLeft,
    Direction.bottom,
    Direction.bottomRight,
    Direction.right,
    Direction.topRight,
  ]);

  final List<Direction> _directionList = [
    Direction.top,
    Direction.bottom,
    Direction.left,
    Direction.right
  ];
  final HashSet<int> _doNotMoveTiles = HashSet();

  Future<void> solve() async {
    List<int> solutionOrder = _getSolutionOrder();

    for (int tileNum in solutionOrder) {
      // if user reset the board, then no longer looking for solution
      if (!puzzleBoard.isLookingForSolution) {
        puzzleBoard.resetBoard();
        break;
      }

      final Coordinate correctPosition = findCorrectTileCoordinate(
        index: tileNum,
        numRowsOrColumns: puzzleBoard.numRowsOrColumns,
      );
      final Coordinate curPos = puzzleBoard.findCurrentTileCoordiante(tileNum);

      // if tile number is in correct position
      if (correctPosition == curPos) {
        _doNotMoveTiles.add(tileNum);
        // if there are 9 remaining tiles to solves
      } else if (puzzleBoard.numRowsOrColumns - correctPosition.row < 4 &&
          puzzleBoard.numRowsOrColumns - correctPosition.col < 4) {
        await _runIDAStar();
        break;
        // if tile needs to move to top right corner
      } else if (correctPosition.col == puzzleBoard.numRowsOrColumns - 1) {
        final int prevTileNum = tileNum - 1;
        await _moveTileToCorner(
          tileNum: tileNum,
          correctPosition: correctPosition,
          prevTileNum: prevTileNum,
          corner: CornerCase.topRight,
        );
        // if tile needs to move to bottom left corner
      } else if (correctPosition.row == puzzleBoard.numRowsOrColumns - 1) {
        final int prevTileNum = tileNum - puzzleBoard.numRowsOrColumns;
        await _moveTileToCorner(
          tileNum: tileNum,
          correctPosition: correctPosition,
          prevTileNum: prevTileNum,
          corner: CornerCase.bottomLeft,
        );
      } else {
        await _moveTileToTarget(tileNum: tileNum, target: correctPosition);
        _doNotMoveTiles.add(tileNum);
      }
    }
  }

  /// this method moves the blank tile to given position
  Future<void> _moveBlankTileToTarget({required Coordinate target}) async {
    Coordinate curBlankCoord = puzzleBoard.currentBlankTileCoordiante;

    // we are using 1.5 as the cut off because blank tiles can move
    // target tile from the corner poistions
    while (_calcEuclindianDistance(start: target, end: curBlankCoord) > 1.5) {
      // find the best valid path that puts the blank tile closer to target
      double minDistance = double.infinity;
      late Direction shortestDir;
      for (var direction in _directionList) {
        final Coordinate adjTile =
            curBlankCoord.calculateAdjacent(direction: direction);
        final double curDistance =
            _calcEuclindianDistance(start: target, end: adjTile);

        if (curDistance < minDistance && _isValidPath(node: adjTile)) {
          minDistance = curDistance;
          shortestDir = direction;
        }
      }

      puzzleBoard.moveTilesUsingCurrentCoordinates(
        curCoord: curBlankCoord.calculateAdjacent(direction: shortestDir),
      );
      curBlankCoord = puzzleBoard.currentBlankTileCoordiante;
      await Future.delayed(aiTileSpeed);
    }
  }

  Future<void> _moveTileInDirection({
    required int tileNum,
    required Direction moveDirection,
  }) async {
    assert(moveDirection != Direction.topLeft);
    assert(moveDirection != Direction.topRight);
    assert(moveDirection != Direction.bottomLeft);
    assert(moveDirection != Direction.bottomRight);

    // get target tile current position
    Coordinate curTargetCoord = puzzleBoard.findCurrentTileCoordiante(tileNum);

    // check if move is out of bounds
    if (isOutOfBounds1d(
      length: puzzleBoard.numRowsOrColumns,
      curPoint: curTargetCoord.calculateAdjacent(direction: moveDirection),
    )) return;

    // check if it is adjacent to blank tile, if not move blank tile adjacent
    if (!puzzleBoard.isAdjacentToEmptyTile(curTargetCoord)) {
      await _moveBlankTileToTarget(target: curTargetCoord);
    }

    // check clockwise path starting from target direction to blank tile
    Queue<Coordinate> clockwiseMoveList = _getPathToTargetLocation(
      directionList: _clockwise,
      moveDirection: moveDirection,
      targetTilePos: curTargetCoord,
      targetTileNum: tileNum,
    );

    // check counter clockwise path starting from target direction to blank tile
    Queue<Coordinate> counterClockwiseMoveList = _getPathToTargetLocation(
      directionList: _counterclockwise,
      moveDirection: moveDirection,
      targetTilePos: curTargetCoord,
      targetTileNum: tileNum,
    );

    // compare which takes less moves to blank tile without touch correctly placed tiles
    Queue<Coordinate> shortestPath = _getShortestPath(
      path1: clockwiseMoveList,
      path2: counterClockwiseMoveList,
    );

    // move blank tile to target spot
    await _moveBlankTileWithQueue(shortestPath);
  }

  // gets the shortest path
  Queue<Coordinate> _getShortestPath({
    required Queue<Coordinate> path1,
    required Queue<Coordinate> path2,
  }) {
    if (path1.isEmpty) {
      return path2;
    } else if (path2.isEmpty) {
      return path1;
    }

    return (path1.length < path2.length) ? path1 : path2;
  }

  Queue<Coordinate> _getPathToTargetLocation({
    required Queue<Direction> directionList,
    required Direction moveDirection,
    required Coordinate targetTilePos,
    required int targetTileNum,
  }) {
    // set directionList to correct starting direction
    // to calculate shortest path to target location
    while (directionList.first != moveDirection) {
      directionList.add(directionList.removeFirst());
    }

    // get correct blank tile
    Coordinate curBlankCoord = puzzleBoard.currentBlankTileCoordiante;
    Coordinate adjTile;

    Queue<Coordinate> moveList = Queue();

    do {
      adjTile = targetTilePos.calculateAdjacent(direction: directionList.first);
      directionList.add(directionList.removeFirst());

      // check if tile is valid
      if (!_isValidPath(node: adjTile)) {
        moveList.clear();
        return moveList;
      }
      // add moveList to queue
      moveList.addFirst(adjTile);
    } while (curBlankCoord != adjTile);

    // remove blank tile position from queue
    if (moveList.isNotEmpty) moveList.removeFirst();
    // add last move to move target node to blank space
    moveList.add(targetTilePos);

    return moveList;
  }

  /// Returns a list of tile numbers in the order it should be sovled
  List<int> _getSolutionOrder() {
    List<int> solutionOrder = [];
    int length = puzzleBoard.numRowsOrColumns;

    // iterates diagonally (0,0), (1,1), (2,2)...
    for (int initalRowAndCol = 0; initalRowAndCol < length; ++initalRowAndCol) {
      for (int col = initalRowAndCol; col < length; ++col) {
        solutionOrder.add(initalRowAndCol * length + col);
      }

      for (int row = initalRowAndCol + 1; row < length; ++row) {
        solutionOrder.add(row * length + initalRowAndCol);
      }
    }
    return solutionOrder;
  }

  bool _isValidPath({required Coordinate node}) {
    return !isOutOfBounds1d(
          length: puzzleBoard.numRowsOrColumns,
          curPoint: node,
        ) &&
        !_doNotMoveTiles.contains(
          puzzleBoard.curPositionMatrix[node.row][node.col],
        );
  }

  Future<void> _moveTileToTarget({
    required int tileNum,
    required Coordinate target,
  }) async {
    Coordinate currentPosition = puzzleBoard.findCurrentTileCoordiante(tileNum);
    // while tile is not in correct position
    while (_calcEuclindianDistance(start: target, end: currentPosition) > 0) {
      // get the direction that moves closest to target position
      late Direction shortestDir;
      double minDistance = double.infinity;
      // top, left, right, bottom check which path gets closer to desired position
      for (Direction direction in _directionList) {
        Coordinate adjPosition =
            currentPosition.calculateAdjacent(direction: direction);
        double curDistance =
            _calcEuclindianDistance(start: target, end: adjPosition);

        if (curDistance < minDistance && _isValidPath(node: adjPosition)) {
          minDistance = curDistance;
          shortestDir = direction;
        }
      }
      await _moveTileInDirection(tileNum: tileNum, moveDirection: shortestDir);
      currentPosition =
          currentPosition.calculateAdjacent(direction: shortestDir);
    }
  }

  double _calcEuclindianDistance({
    required Coordinate start,
    required Coordinate end,
  }) {
    return sqrt(pow(start.col - end.col, 2) + pow(start.row - end.row, 2));
  }

  Future<void> _runIDAStar() async {
    IDAStarPuzzleSolver puzzleSolver = IDAStarPuzzleSolver(
      initialBoardState: puzzleBoard.flattenCorrectPositionMatrix(),
      numRowsOrColumns: puzzleBoard.numRowsOrColumns,
      blankTileCoordinate: puzzleBoard.currentBlankTileCoordiante,
    );
    Queue<Coordinate> moveList = puzzleSolver.solvePuzzle();
    await _moveBlankTileWithQueue(moveList);
  }

  Future<void> _moveBlankTileWithQueue(Queue<Coordinate> moveList) async {
    while (moveList.isNotEmpty) {
      final Coordinate curCoord = moveList.removeFirst();
      puzzleBoard.moveTilesUsingCurrentCoordinates(curCoord: curCoord);
      await Future.delayed(aiTileSpeed);
    }
  }

  Future<void> _moveTileToCorner({
    required int tileNum,
    required Coordinate correctPosition,
    required int prevTileNum,
    required CornerCase corner,
  }) async {
    Direction curDirection =
        (corner == CornerCase.bottomLeft) ? Direction.right : Direction.bottom;

    // move correct tile two spaces away from correct position
    await _moveTileToTarget(
      tileNum: tileNum,
      target: correctPosition
          .calculateAdjacent(direction: curDirection)
          .calculateAdjacent(direction: curDirection),
    );
    // lock the current element so it doesn't move
    _doNotMoveTiles.add(tileNum);

    // unlock previous element
    _doNotMoveTiles.remove(prevTileNum);
    await _moveTileToTarget(tileNum: prevTileNum, target: correctPosition);

    // lock previous element after moving
    _doNotMoveTiles.add(prevTileNum);

    // move target element next to previous element
    await _moveTileToTarget(
      tileNum: tileNum,
      target: correctPosition.calculateAdjacent(direction: curDirection),
    );

    // remove prev tile from previous element and move element to correct position
    _doNotMoveTiles.remove(prevTileNum);
    _doNotMoveTiles.remove(tileNum);

    await _moveTileToTarget(tileNum: tileNum, target: correctPosition);

    _doNotMoveTiles.add(tileNum);
    _doNotMoveTiles.add(prevTileNum);
  }
}

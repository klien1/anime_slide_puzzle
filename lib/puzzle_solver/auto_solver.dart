import 'dart:math';

import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'dart:collection';
import 'package:anime_slide_puzzle/constants.dart';

enum CornerCase { topRight, bottomLeft }

class AutoSolver {
  AutoSolver({
    required this.puzzleBoard,
  });
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

    for (int element in solutionOrder) {
      final Coordinate correctPosition = convert1dArrayCoordTo2dArrayCoord(
        index: element,
        numRowOrColCount: puzzleBoard.numRowsOrColumns,
      );
      final Coordinate curElementCoordainte =
          puzzleBoard.findCurrentTileNumberCoordiante(element);

      if (correctPosition == curElementCoordainte) {
        _doNotMoveTiles.add(element);
      } else if (puzzleBoard.numRowsOrColumns - correctPosition.row < 4 &&
          puzzleBoard.numRowsOrColumns - correctPosition.col < 4) {
        await _runIDAStar();

        break;
      } else if (correctPosition.col == puzzleBoard.numRowsOrColumns - 1) {
        final int previousElement = element - 1;
        await _moveTileToCorner(
          element,
          correctPosition,
          previousElement,
          CornerCase.topRight,
        );
      } else if (correctPosition.row == puzzleBoard.numRowsOrColumns - 1) {
        final int previousElement = element - puzzleBoard.numRowsOrColumns;
        await _moveTileToCorner(
          element,
          correctPosition,
          previousElement,
          CornerCase.bottomLeft,
        );
      } else {
        await _moveTileToTargetPosition(element, correctPosition);
        _doNotMoveTiles.add(element);
      }
    }
  }

  Future<void> _moveBlankTileNextToTarget(Coordinate target) async {
    Coordinate blankCoord = puzzleBoard.currentBlankTileCoordiante;

    while (_getEuclindianDistance(target, blankCoord) > 1) {
      // find the best valid path that puts the blank tile closer to target
      double minDistance = double.infinity;
      late Direction correctDirection;
      for (var direction in _directionList) {
        final Coordinate adjTile =
            blankCoord.calculateAdjacent(direction: direction);
        final double curDistance = _getEuclindianDistance(target, adjTile);

        if (curDistance < minDistance && _isValidPath(adjTile)) {
          minDistance = curDistance;
          correctDirection = direction;
        }
      }

      assert(correctDirection != null);

      _swapTileUsingCurrentCoordinate(
          blankCoord.calculateAdjacent(direction: correctDirection));
      // _moveBlankTile(correctDirection);
      blankCoord = puzzleBoard.currentBlankTileCoordiante;
      await Future.delayed(defaultTileSpeed);
    }
  }

  Future<void> _moveNumberTileDirection(
      int tileNum, Direction moveDirection) async {
    assert(moveDirection != Direction.topLeft);
    assert(moveDirection != Direction.topRight);
    assert(moveDirection != Direction.bottomLeft);
    assert(moveDirection != Direction.bottomRight);

    // get target tile current position
    Coordinate targetTileCurrentCoordinate =
        puzzleBoard.findCurrentTileNumberCoordiante(tileNum);

    // check if move is out of bounds
    if (isOutOfBounds1d(
      puzzleBoard.numRowsOrColumns,
      targetTileCurrentCoordinate.calculateAdjacent(
        direction: moveDirection,
      ),
    )) return;

    // check if it is adjacent to blank tile, if not move blank tile adjacent
    if (!puzzleBoard.isAdjacentToEmptyTile(targetTileCurrentCoordinate)) {
      await _moveBlankTileNextToTarget(targetTileCurrentCoordinate);
    }

    // check clockwise path starting from target direction to blank tile
    Queue<Coordinate> clockwiseMoveList = _getPathToTargetLocation(
      directionList: _clockwise,
      moveDirection: moveDirection,
      targetTilePos: targetTileCurrentCoordinate,
      targetTileNum: tileNum,
    );

    // check counter clockwise path starting from target direction to blank tile
    Queue<Coordinate> counterClockwiseMoveList = _getPathToTargetLocation(
      directionList: _counterclockwise,
      moveDirection: moveDirection,
      targetTilePos: targetTileCurrentCoordinate,
      targetTileNum: tileNum,
    );

    // compare which takes less moves to blank tile without touch correctly placed tiles
    Queue<Coordinate> shortestPath = _getShortestPath(
      clockwiseMoveList,
      counterClockwiseMoveList,
    );

    // move blank tile to target spot
    while (shortestPath.isNotEmpty) {
      Coordinate curCoordinate = shortestPath.removeFirst();
      _swapTileUsingCurrentCoordinate(curCoordinate);
      await Future.delayed(defaultTileSpeed);
    }
  }

  void _swapTileUsingCurrentCoordinate(Coordinate curCoordinate) {
    int tileNum = puzzleBoard.puzzleTileNumberMatrix[curCoordinate.row]
        [curCoordinate.col];

    puzzleBoard.moveTile(
        correctTileCoordinate: convert1dArrayCoordTo2dArrayCoord(
      index: tileNum,
      numRowOrColCount: puzzleBoard.numRowsOrColumns,
    ));
  }

  // gets the shortest path
  Queue<Coordinate> _getShortestPath(
      Queue<Coordinate> path1, Queue<Coordinate> path2) {
    if (path1.isEmpty) {
      return path2;
    } else if (path2.isEmpty) {
      return path1;
    }

    return (path1.length < path2.length) ? path1 : path2;
  }

  // sets the queue to start at target direction
  void _setQueueStartingDirection(
      Queue<Direction> directionList, Direction targetDirection) {
    while (directionList.first != targetDirection) {
      directionList.add(directionList.removeFirst());
    }
  }

  Queue<Coordinate> _getPathToTargetLocation({
    required Queue<Direction> directionList,
    required Direction moveDirection,
    required Coordinate targetTilePos,
    required int targetTileNum,
  }) {
    // set directList to correct starting direction
    _setQueueStartingDirection(directionList, moveDirection);

    // get correct blank tile
    Coordinate curBlankCoord = puzzleBoard.currentBlankTileCoordiante;
    Coordinate tilesSurroundingTarget;

    Queue<Coordinate> moveList = Queue();

    do {
      tilesSurroundingTarget =
          targetTilePos.calculateAdjacent(direction: directionList.first);
      directionList.add(directionList.removeFirst());

      // check if tile is valid
      if (!_isValidPath(tilesSurroundingTarget)) {
        moveList.clear();
        return moveList;
      }
      // add moveList to queue
      moveList.addFirst(tilesSurroundingTarget);
    } while (curBlankCoord != tilesSurroundingTarget);

    // remove blank tile position from queue
    if (moveList.isNotEmpty) moveList.removeFirst();
    // add last move to move target node to blank space
    moveList.add(targetTilePos);

    return moveList;
  }

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

  bool _isValidPath(Coordinate node) {
    return !isOutOfBounds1d(
          puzzleBoard.numRowsOrColumns,
          node,
        ) &&
        !_doNotMoveTiles.contains(
          puzzleBoard.puzzleTileNumberMatrix[node.row][node.col],
        );
  }

  Future<void> _moveTileToTargetPosition(
    int target,
    Coordinate targetPosition,
  ) async {
    Coordinate currentPosition =
        puzzleBoard.findCurrentTileNumberCoordiante(target);
    // while tile is not in correct position
    while (_getEuclindianDistance(targetPosition, currentPosition) > 0) {
      // get the direction that moves closest to target position
      late Direction correctDirection;
      double minDistance = double.infinity;
      // top, left, right, bottom check which path gets closer to desired position
      for (Direction direction in _directionList) {
        Coordinate adjPosition =
            currentPosition.calculateAdjacent(direction: direction);
        double curDistance =
            _getEuclindianDistance(targetPosition, adjPosition);

        if (curDistance < minDistance && _isValidPath(adjPosition)) {
          minDistance = curDistance;
          correctDirection = direction;
        }
      }
      await _moveNumberTileDirection(target, correctDirection);
      currentPosition =
          currentPosition.calculateAdjacent(direction: correctDirection);
      await Future.delayed(defaultTileSpeed);
    }
  }

  double _getEuclindianDistance(Coordinate first, Coordinate second) {
    return sqrt(
      pow(first.col - second.col, 2) + pow(first.row - second.row, 2),
    );
  }

  Future<void> _runIDAStar() async {
    List<int> flatten = [];
    for (List<int> element in puzzleBoard.puzzleTileNumberMatrix) {
      flatten.addAll(element);
    }

    IDAStarPuzzleSolver puzzleSolver = IDAStarPuzzleSolver(
      initialBoardState: flatten,
      numRowsOrColumns: puzzleBoard.numRowsOrColumns,
      blankTileCoordinate: puzzleBoard.currentBlankTileCoordiante,
    );
    Queue<Coordinate> moveList = puzzleSolver.solvePuzzle();
    while (moveList.isNotEmpty) {
      final Coordinate curCoordinate = moveList.removeFirst();
      _swapTileUsingCurrentCoordinate(curCoordinate);
      await Future.delayed(defaultTileSpeed);
    }
  }

  Future<void> _moveTileToCorner(
    int element,
    Coordinate correctPosition,
    int previousElement,
    CornerCase corner,
  ) async {
    Direction curElementDirection =
        (corner == CornerCase.bottomLeft) ? Direction.right : Direction.bottom;

    // move correct tile two spaces away from correct position
    await _moveTileToTargetPosition(
      element,
      correctPosition
          .calculateAdjacent(direction: curElementDirection)
          .calculateAdjacent(direction: curElementDirection),
    );
    // lock the current element so it doesn't move
    _doNotMoveTiles.add(element);

    // unlock previous element
    _doNotMoveTiles.remove(previousElement);
    await _moveTileToTargetPosition(previousElement, correctPosition);

    // lock previous element after moving
    _doNotMoveTiles.add(previousElement);

    // move target element next to previous element
    await _moveTileToTargetPosition(
      element,
      correctPosition.calculateAdjacent(direction: curElementDirection),
    );

    // remove prev tile from previous element and move element to correct position
    _doNotMoveTiles.remove(previousElement);
    _doNotMoveTiles.remove(element);

    await _moveTileToTargetPosition(
      element,
      correctPosition,
    );

    _doNotMoveTiles.add(element);
    _doNotMoveTiles.add(previousElement);
  }
}

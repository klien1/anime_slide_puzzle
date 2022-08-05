import 'dart:math';

import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'dart:collection';

import 'package:flutter/cupertino.dart';

const kIntMax = 99999;
const Duration tileSpeed = Duration(milliseconds: 100);

class BlankTileController {
  BlankTileController({
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
  HashSet<int> correctlyPoistioned = HashSet();

// TODO: Check for valid path and if using correctly placed tiles
  @visibleForTesting
  void moveBlankTile(Direction direction) {
    Coordinate blankTileCoordinate = puzzleBoard.currentBlankTileCoordiante;
    // List<List<int>> matrix = puzzleBoard.puzzleTileNumberMatrix;

    // get correct coordinate
    Coordinate adjCoordiante =
        blankTileCoordinate.calculateAdjacent(direction: direction);

    if (isOutOfBounds1d(puzzleBoard.numRowsOrColumns, adjCoordiante)) return;

    moveTileWithCurrentCoordinate(adjCoordiante);
  }

  @visibleForTesting
  Future<void> moveBlankTileNextToTarget(Coordinate target) async {
    Coordinate blankCoord = puzzleBoard.currentBlankTileCoordiante;

    while (getManhattanDistance(target, blankCoord) > 1) {
      if ((target.row - blankCoord.row).abs() > 0) {
        if (target.row - blankCoord.row < 0) {
          moveBlankTile(Direction.top);
        } else if (target.row - blankCoord.row > 0) {
          moveBlankTile(Direction.bottom);
        }
      } else if ((target.col - blankCoord.col).abs() > 0) {
        if (target.col - blankCoord.col < 0) {
          moveBlankTile(Direction.left);
        } else if (target.col - blankCoord.col > 0) {
          moveBlankTile(Direction.right);
        }
      }
      blankCoord = puzzleBoard.currentBlankTileCoordiante;
      await Future.delayed(tileSpeed);
    }
  }

  Future<void> moveNumberTileDirection(
      int tileNum, Direction moveDirection) async {
    assert(moveDirection != Direction.topLeft);
    assert(moveDirection != Direction.topRight);
    assert(moveDirection != Direction.bottomLeft);
    assert(moveDirection != Direction.bottomRight);

    // get target tile current position
    Coordinate targetTileCurrentCoordinate =
        puzzleBoard.findCurrentTileNumberCoordiante(tileNum);
    // print('targetTileCurrentCoordinate = $targetTileCurrentCoordinate');
    // print(
    //     'moving $targetTileCurrentCoordinate to ${targetTileCurrentCoordinate.calculateAdjacent(direction: moveDirection)}');

    // check if move is out of bounds
    if (isOutOfBounds1d(
      puzzleBoard.numRowsOrColumns,
      targetTileCurrentCoordinate.calculateAdjacent(
        direction: moveDirection,
      ),
    )) return;

    // check if it is adjacent to blank tile, if not move blank tile adjacent
    if (!puzzleBoard.isAdjacentToEmptyTile(targetTileCurrentCoordinate)) {
      await moveBlankTileNextToTarget(targetTileCurrentCoordinate);
    }

    // check clockwise path starting from target direction to blank tile
    Queue<Coordinate> clockwiseMoveList = getPathToTargetLocation(
      directionList: _clockwise,
      moveDirection: moveDirection,
      targetTilePos: targetTileCurrentCoordinate,
      targetTileNum: tileNum,
    );

    // check counter clockwise path starting from target direction to blank tile
    Queue<Coordinate> counterClockwiseMoveList = getPathToTargetLocation(
      directionList: _counterclockwise,
      moveDirection: moveDirection,
      targetTilePos: targetTileCurrentCoordinate,
      targetTileNum: tileNum,
    );

    print('$clockwiseMoveList vs $counterClockwiseMoveList');

    // compare which takes less moves to blank tile without touch correctly placed tiles
    Queue<Coordinate> bestPath = getBestPath(
      clockwiseMoveList,
      counterClockwiseMoveList,
    );

    // move blank tile to target spot
    while (bestPath.isNotEmpty) {
      Coordinate curCoordinate = bestPath.removeFirst();
      moveTileWithCurrentCoordinate(curCoordinate);
      await Future.delayed(tileSpeed);
    }
    // move target tile with blank tile using target correct coordinate
    moveTileWithCurrentCoordinate(targetTileCurrentCoordinate);
  }

  void moveTileWithCurrentCoordinate(Coordinate curCoordinate) {
    int tileNum = puzzleBoard.puzzleTileNumberMatrix[curCoordinate.row]
        [curCoordinate.col];

    puzzleBoard.moveTile(
        correctTileCoordinate: convert1dArrayCoordTo2dArrayCoord(
      index: tileNum,
      numRowOrColCount: puzzleBoard.numRowsOrColumns,
    ));
  }

  // gets the shortest path
  @visibleForTesting
  Queue<Coordinate> getBestPath(
      Queue<Coordinate> path1, Queue<Coordinate> path2) {
    if (path1.isEmpty) {
      return path2;
    } else if (path2.isEmpty) {
      return path1;
    }

    return (path1.length < path2.length) ? path1 : path2;
  }

  void setQueueStartingDirection(
      Queue<Direction> directionList, Direction targetDirection) {
    while (directionList.first != targetDirection) {
      directionList.add(directionList.removeFirst());
    }
  }

  @visibleForTesting
  Queue<Coordinate> getPathToTargetLocation({
    required Queue<Direction> directionList,
    required Direction moveDirection,
    required Coordinate targetTilePos,
    required int targetTileNum,
  }) {
    // set directList to correct starting direction
    setQueueStartingDirection(directionList, moveDirection);

    // get correct blank tile
    Coordinate curBlankCoord = puzzleBoard.currentBlankTileCoordiante;
    Coordinate tilesSurroundingTarget;

    Queue<Coordinate> moveList = Queue();

    do {
      tilesSurroundingTarget =
          targetTilePos.calculateAdjacent(direction: directionList.first);
      directionList.add(directionList.removeFirst());

      // check if tile is valid
      print(correctlyPoistioned);
      if (isOutOfBounds1d(
              puzzleBoard.numRowsOrColumns, tilesSurroundingTarget) ||
          correctlyPoistioned.contains(
              puzzleBoard.puzzleTileNumberMatrix[tilesSurroundingTarget.row]
                  [tilesSurroundingTarget.col])) {
        moveList.clear();
        return Queue();
      }
      // add moveList to queue
      moveList.addFirst(tilesSurroundingTarget);
    } while (curBlankCoord != tilesSurroundingTarget);

    print('$targetTileNum - movelist $moveList');

    // remove blank tile position from queue
    if (moveList.isNotEmpty) moveList.removeFirst();

    return moveList;
  }

// TODO: BUG path containing number in set does not move correctly
  Future<void> moveList() async {
    List<int> list = [0, 1, 2, 3, 4, 5];
    for (var element in list) {
      await moveTileToCorrectPosition(element);
    }
  }

  Future<void> moveTileToCorrectPosition(int target) async {
    // get correct position
    Coordinate correctPosition = convert1dArrayCoordTo2dArrayCoord(
      index: target,
      numRowOrColCount: puzzleBoard.numRowsOrColumns,
    );

    Coordinate currentPosition = puzzleBoard
        .puzzleBoard2d[correctPosition.row][correctPosition.col]
        .currentCoordinate;

    // top, left, right, bottom check which path gets closer to desired position
    while (getEuclindianDistance(correctPosition, currentPosition) > 0) {
      // get the direction that moves closest to target position
      late Direction correctDirection;
      double minDistance = double.infinity;
      for (Direction direction in _directionList) {
        Coordinate adjPosition =
            currentPosition.calculateAdjacent(direction: direction);
        double curDistance =
            getEuclindianDistance(correctPosition, adjPosition);

        if (curDistance < minDistance &&
            !isOutOfBounds1d(
              puzzleBoard.numRowsOrColumns,
              adjPosition,
            ) &&
            !correctlyPoistioned.contains(
              puzzleBoard.puzzleTileNumberMatrix[adjPosition.row]
                  [adjPosition.col],
            )) {
          minDistance = curDistance;
          correctDirection = direction;
        }
      }
      print(correctDirection);
      await moveNumberTileDirection(target, correctDirection);
      currentPosition =
          currentPosition.calculateAdjacent(direction: correctDirection);
      await Future.delayed(tileSpeed);
    }
    correctlyPoistioned.add(target);
  }

  double getEuclindianDistance(Coordinate first, Coordinate second) {
    return sqrt(
      pow(first.col - second.col, 2) + pow(first.row - second.row, 2),
    );
  }
}

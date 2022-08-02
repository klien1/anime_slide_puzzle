import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:anime_slide_puzzle/models/puzzleSolver/a_star_node.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:collection/collection.dart';
import 'dart:collection';

class PuzzleSolver {
  final List<List<int>> _startingBoardState;
  late final AStarNode _goalState;
  // late final int _rowOrColCount;
  // late final int _blankTileValueNumber;

  PuzzleSolver({required startingBoardState})
      : _startingBoardState = startingBoardState
  // _rowOrColCount = sqrt(startingBoardState.length).toInt(),
  // _blankTileValueNumber =
  // startingBoardState.length * startingBoardState.length - 1
  {
    _goalState = AStarNode(boardState: generateGoalState());
  }

  @visibleForTesting
  List<List<int>> generateGoalState() {
    return List.generate(
      _startingBoardState.length,
      (row) => List.generate(_startingBoardState.length,
          (col) => row * _startingBoardState.length + col),
    );
  }

  Queue<Coordinate> solvePuzzle() {
    AStarNode curBoardState = AStarNode(boardState: _startingBoardState);
    Queue<Coordinate> moveList = Queue();
    // checks to see if puzzle is solvable
    if (!PuzzleBoard.isPuzzleIsSolvable(
        matrix: curBoardState.boardState,
        blankTileRow: curBoardState.getBlankTileCoordiante().row)) {
      return moveList;
    }

    HashSet<AStarNode> visited = HashSet();

    HeapPriorityQueue<AStarNode> heapPriorityQueue = HeapPriorityQueue(
        (first, second) => (first.heuristic - second.heuristic).toInt());

    heapPriorityQueue.add(curBoardState);

    while (heapPriorityQueue.isNotEmpty) {
      curBoardState = heapPriorityQueue.removeFirst();
      if (curBoardState == _goalState) break; // found solution

      // down
      addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        row: 1,
      );

      // up
      addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        row: -1,
      );

      // right
      addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        col: 1,
      );

      //left
      addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        col: -1,
      );
    }

    AStarNode? temp = curBoardState;
    while (temp!.prevBoardState != null) {
      // while (temp != null) {
      for (var list in temp.boardState) {
        print(list);
      }
      print('');

      moveList.addFirst(temp.getBlankTileCoordiante());
      temp = temp.prevBoardState;
    }

    // while (moveList.isNotEmpty) {
    //   print(moveList.removeFirst());
    // }

    return moveList;
  }

  void addNextBoardState({
    required AStarNode curBoardState,
    required HeapPriorityQueue<AStarNode> heapPriorityQueue,
    required HashSet<AStarNode> visited,
    int row = 0,
    int col = 0,
  }) {
    // create new board state, so we don't use the same reference
    List<List<int>> newBoardState = [
      for (List<int> row in curBoardState.boardState) [...row]
    ];

    // swap poistions and returns true if successful
    Coordinate curBlankCoordinate = curBoardState.getBlankTileCoordiante();
    bool successfulSwap = PuzzleBoard.swapTileNumbers(
      matrix: newBoardState,
      first: curBlankCoordinate,
      second: curBlankCoordinate.calculateAdjacent(row: row, col: col),
    );

    AStarNode newNode = AStarNode(
      boardState: newBoardState,
      curMove: curBoardState.curMove + 1,
      prevBoardState: curBoardState,
    );

    // if swap was successful and node has not been visited, then add to queue
    if (successfulSwap && !visited.contains(newNode)) {
      visited.add(newNode);
      heapPriorityQueue.add(newNode);
    }
  }
}

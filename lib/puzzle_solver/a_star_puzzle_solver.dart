import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/puzzle_solver/a_star_node.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:collection/collection.dart';
import 'package:anime_slide_puzzle/puzzle_solver/puzzle_solver_helper.dart';
import 'dart:collection';

class AStarPuzzleSolver {
  final List<List<int>> _startingBoardState;
  late final AStarNode _goalState;

  AStarPuzzleSolver({
    required List<List<int>> startingBoardState,
    required Coordinate currentBlankTileCoordiante,
  }) : _startingBoardState = startingBoardState {
    _goalState = AStarNode(
        initialBoardState: generateGoalState(startingBoardState.length),
        blankTileCoordinate: currentBlankTileCoordiante);
  }

  Queue<Coordinate> solvePuzzle(Coordinate blankTileCoordinate) {
    AStarNode curBoardState = AStarNode(
      initialBoardState: _startingBoardState,
      blankTileCoordinate: blankTileCoordinate,
    );
    Queue<Coordinate> moveList = Queue();
    // checks to see if puzzle is solvable
    if (!PuzzleBoard.isPuzzleIsSolvable(
        matrix: curBoardState.boardState,
        blankTileRow: curBoardState.getBlankTileCoordinate.row)) {
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
      _addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        row: 1,
      );

      // up
      _addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        row: -1,
      );

      // right
      _addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        col: 1,
      );

      //left
      _addNextBoardState(
        curBoardState: curBoardState,
        heapPriorityQueue: heapPriorityQueue,
        visited: visited,
        col: -1,
      );
    }

    AStarNode? temp = curBoardState;
    while (temp!.prevBoardState != null) {
      moveList.addFirst(temp.getBlankTileCoordinate);
      temp = temp.prevBoardState;
    }
    return moveList;
  }

  void _addNextBoardState({
    required AStarNode curBoardState,
    required HeapPriorityQueue<AStarNode> heapPriorityQueue,
    required HashSet<AStarNode> visited,
    int row = 0,
    int col = 0,
  }) {
    // create new board state, so we don't use the same reference
    List<List<int>> newBoardState = copyBoardState(curBoardState.boardState);

    // swap poistions and returns true if successful
    Coordinate curBlankCoordinate = curBoardState.getBlankTileCoordinate;
    Coordinate newBlankCoordiantePosition =
        curBlankCoordinate.calculateAdjacent(row: row, col: col);
    bool successfulSwap = PuzzleBoard.swapTileNumbers(
      matrix: newBoardState,
      first: curBlankCoordinate,
      second: newBlankCoordiantePosition,
    );

    // if swap wasn't successful exit method
    if (!successfulSwap) return;

    // exit method if new board state is the same as previous state
    if (isSameMatrix(curBoardState.boardState, newBoardState)) {
      return;
    }

    AStarNode newNode = AStarNode(
      initialBoardState: newBoardState,
      blankTileCoordinate: newBlankCoordiantePosition,
      curMove: curBoardState.curMove + 1,
      prevBoardState: curBoardState,
    );

    // if node has not been visited, then add to queue
    if (!visited.contains(newNode)) {
      visited.add(newNode);
      heapPriorityQueue.add(newNode);
    }
  }
}

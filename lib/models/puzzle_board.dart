import 'dart:async';
import 'dart:collection';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/ida_star_puzzle_solver.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:anime_slide_puzzle/puzzle_solver/a_star_puzzle_solver.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'dart:math';

class PuzzleBoard extends ChangeNotifier {
  final int _numRowsOrColumns;
  late List<List<PuzzleTile>> _puzzleTiles2d;
  late List<List<int>> _puzzleTileNumberMatrix;
  int _numberOfMoves = 0;
  double _currentTileOpacity = 0;
  bool _gameInProgress = false;
  bool _solutionInProgress = false;

  PuzzleBoard({required numRowsOrColumns})
      : _numRowsOrColumns = numRowsOrColumns {
    _puzzleTiles2d = _generatePuzzleMatrix(numRowsOrColumns);

    _puzzleTileNumberMatrix = List.generate(
        _numRowsOrColumns,
        (row) => List.generate(
            _numRowsOrColumns, (col) => row * _numRowsOrColumns + col,
            growable: false),
        growable: false);
  }

  PuzzleBoard.board({required List<List<PuzzleTile>> board})
      : _puzzleTiles2d = board,
        _numRowsOrColumns = board.length;

  PuzzleBoard.intBoard({required List<List<int>> board})
      : _numRowsOrColumns = board.length {
    _puzzleTiles2d = _generatePuzzleMatrix(numRowsOrColumns);
    for (int row = 0; row < board.length; ++row) {
      for (int col = 0; col < board.length; ++col) {
        board[row][col]; // value
        Coordinate correctCoordinate = convert1dArrayCoordTo2dArrayCoord(
            index: board[row][col], numRowOrColCount: numRowsOrColumns);

        _puzzleTiles2d[correctCoordinate.row][correctCoordinate.col]
            .currentCoordinate = correctCoordinate;
      }
    }

    _puzzleTileNumberMatrix = board;
  }

  List<List<PuzzleTile>> _generatePuzzleMatrix(int numRowsOrCols) {
    return List.generate(
        _numRowsOrColumns,
        (row) => List.generate(
            _numRowsOrColumns,
            (col) => PuzzleTile(
                  correctCoordinate: Coordinate(row: row, col: col),
                  currentCoordinate: Coordinate(row: row, col: col),
                  tileNumber: row * _numRowsOrColumns + col,
                  isBlank: (row == _numRowsOrColumns - 1 &&
                          col == _numRowsOrColumns - 1)
                      ? true
                      : false,
                ),
            growable: false),
        growable: false);
  }

  // tries to swap values for 2d matrix if it is within boundary
  // returns true if swap was successful
  static bool swapTileNumbers({
    required List<List<int>> matrix,
    required Coordinate first,
    required Coordinate second,
  }) {
    // check if coordinates are within boundary
    if (isOutOfBounds(matrix, first) || isOutOfBounds(matrix, second)) {
      return false;
    }

    final int tempVal = matrix[first.row][first.col];
    matrix[first.row][first.col] = matrix[second.row][second.col];
    matrix[second.row][second.col] = tempVal;
    return true;
  }

  // checks is coordinate is out of bounds in matrix
  static bool isOutOfBounds(
    List<List<int>> matrix,
    Coordinate curPoint,
  ) {
    if (curPoint.row < 0 ||
        curPoint.col < 0 ||
        curPoint.row >= matrix.length ||
        curPoint.col >= matrix[curPoint.row].length) {
      return true;
    }

    return false;
  }

  static bool isPuzzleIsSolvable({
    required List<List<int>> matrix,
    required int blankTileRow,
  }) {
    int numRowsOrColumns = matrix.length;
    int numInversions = countTotalInversion(matrix: matrix);

    if ((!isEven(numRowsOrColumns) && isEven(numInversions)) ||
        isEven(numRowsOrColumns) && !isEven(numInversions + blankTileRow)) {
      return true;
    }

    return false;
  }

  // Count # of inversions
  // An inversion is any pair of tiles i and j where i < j
  // but i appears after j when considering the board in row-major order
  static int countTotalInversion({required List<List<int>> matrix}) {
    int numRowsOrColumns = matrix.length;

    List<int> currentTilePosition1d = [];
    for (var element in matrix) {
      currentTilePosition1d.addAll(element);
    }

    return countInversion(
      currentTilePosition1d,
      numRowsOrColumns * numRowsOrColumns - 1,
    );
  }

  static int countInversion(List<int> tileNumberList, int blankTileNum) {
    int numInversions = 0;

    for (int i = 0; i < tileNumberList.length; ++i) {
      final curVal = tileNumberList[i];
      for (int j = i + 1; j < tileNumberList.length; ++j) {
        // skip inversion count if blank tile
        if (curVal == blankTileNum) continue;

        if (curVal > tileNumberList[j]) ++numInversions;
      }
    }
    return numInversions;
  }

  void _toggleSolutionInProgress(bool status) {
    _solutionInProgress = status;
    notifyListeners();
  }

  void _toggleGameInProgress(bool status) {
    _gameInProgress = status;
    notifyListeners();
  }

  void solvePuzzleWithIDAStar() async {
    _toggleSolutionInProgress(true);
    IDAStarPuzzleSolver solver = IDAStarPuzzleSolver(
      initialBoardState: _puzzleTileNumberMatrix,
      blankTileCoordinate: currentBlankTileCoordiante,
    );

    Queue<Coordinate> moveList = solver.solvePuzzle();
    while (moveList.isNotEmpty) {
      Coordinate nextBlankTileCoord = moveList.removeFirst();
      await _aiMoveTile(nextBlankTileCoord);
    }
    _toggleSolutionInProgress(false);
  }

  void solvePuzzleWithAStar() async {
    _toggleSolutionInProgress(true);
    AStarPuzzleSolver puzzleSolver = AStarPuzzleSolver(
      startingBoardState: _puzzleTileNumberMatrix,
      currentBlankTileCoordiante: currentBlankTileCoordiante,
    );

    Queue<Coordinate> moveList =
        puzzleSolver.solvePuzzle(currentBlankTileCoordiante);

    while (moveList.isNotEmpty) {
      Coordinate nextBlankTileCoord = moveList.removeFirst();
      await _aiMoveTile(nextBlankTileCoord);

      // // check which number needs to be swapped
      // int tileNum = _puzzleTileNumberMatrix[nextBlankTileCoord.row]
      //     [nextBlankTileCoord.col];
      // // convert to 2d coordinate
      // Coordinate adjacentTileCoordinate = convert1dArrayCoordTo2dArrayCoord(
      //     index: tileNum, numRowOrColCount: _numRowsOrColumns);
      // // Get tile
      // PuzzleTile adjTile = _puzzleTiles2d[adjacentTileCoordinate.row]
      //     [adjacentTileCoordinate.col];

      // await Future.delayed(const Duration(milliseconds: 200));
      // moveTile(clickedTileCoordinate: adjTile.correctCoordinate);
    }
    _toggleSolutionInProgress(false);
  }

  Future<void> _aiMoveTile(Coordinate nextBlankTileCoord) async {
    // check which number needs to be swapped
    int tileNum =
        _puzzleTileNumberMatrix[nextBlankTileCoord.row][nextBlankTileCoord.col];
    // convert to 2d coordinate
    Coordinate adjacentTileCoordinate = convert1dArrayCoordTo2dArrayCoord(
        index: tileNum, numRowOrColCount: _numRowsOrColumns);
    // Get tile
    PuzzleTile adjTile =
        _puzzleTiles2d[adjacentTileCoordinate.row][adjacentTileCoordinate.col];

    await Future.delayed(const Duration(milliseconds: 200));
    moveTile(clickedTileCoordinate: adjTile.correctCoordinate);
  }

  void moveTile({
    required Coordinate clickedTileCoordinate,
  }) {
    final PuzzleTile clickedTile =
        _puzzleTiles2d[clickedTileCoordinate.row][clickedTileCoordinate.col];

    final PuzzleTile blankTile = _puzzleTiles2d[_correctBlankTileCoordinate.row]
        [_correctBlankTileCoordinate.col];

    if (_isAdjacentToEmptyTile(clickedTile)) {
      _swapTiles(clickedTile, blankTile);
      ++_numberOfMoves;

      if (_isPuzzleTileInCorrectPosition() && _gameInProgress) {
        // print('completed!');
        _toggleGameInProgress(false);
      }

      notifyListeners();
    }
  }

  bool _isAdjacentToEmptyTile(PuzzleTile curTile) {
    Coordinate currentBlankTileCoordinate = currentBlankTileCoordiante;

    return curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(row: 1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(row: -1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(col: 1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(col: -1);
  }

  void startGame() {
    _numberOfMoves = 0;
    _gameInProgress = true;
    _shuffleBoard();
  }

  void _shuffleBoard() {
    do {
      for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
        for (PuzzleTile tile in puzzleList) {
          _swapTiles(tile, _getRandomTile());
        }
      }
    } while (!isPuzzleIsSolvable(
          matrix: _puzzleTileNumberMatrix,
          blankTileRow: currentBlankTileCoordiante.row,
        ) ||
        _isPuzzleTileInCorrectPosition());
    notifyListeners();
  }

  bool _isPuzzleTileInCorrectPosition() {
    for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
      for (PuzzleTile tile in puzzleList) {
        if (tile.correctCoordinate != tile.currentCoordinate) return false;
      }
    }
    return true;
  }

  void toggleTileNumberVisibility() {
    _currentTileOpacity = (_currentTileOpacity == 1) ? 0 : 1;
    notifyListeners();
  }

  PuzzleTile _getRandomTile() {
    Random rng = Random();
    return _puzzleTiles2d[rng.nextInt(_numRowsOrColumns)]
        [rng.nextInt(_numRowsOrColumns)];
  }

  void _swapTiles(
    PuzzleTile firstTile,
    PuzzleTile secondTile,
  ) {
    if (firstTile == secondTile) return;

    final Coordinate temp = firstTile.currentCoordinate;
    firstTile.currentCoordinate = secondTile.currentCoordinate;
    secondTile.currentCoordinate = temp;

    swapTileNumbers(
      matrix: _puzzleTileNumberMatrix,
      first: firstTile.currentCoordinate,
      second: secondTile.currentCoordinate,
    );
  }

  Coordinate get _correctBlankTileCoordinate {
    return _puzzleTiles2d[_numRowsOrColumns - 1][_numRowsOrColumns - 1]
        .correctCoordinate;
  }

  Coordinate get currentBlankTileCoordiante {
    return _puzzleTiles2d[_numRowsOrColumns - 1][_numRowsOrColumns - 1]
        .currentCoordinate;
  }

  int get numRowsOrColumns {
    return _numRowsOrColumns;
  }

  List<List<PuzzleTile>> get puzzleBoard2d {
    return _puzzleTiles2d;
  }

  int get numberOfMoves {
    return _numberOfMoves;
  }

  double get currentTileOpacity {
    return _currentTileOpacity;
  }

  bool get isGameInProgress {
    return _gameInProgress;
  }

  List<List<int>> get puzzleTileNumberMatrix {
    return _puzzleTileNumberMatrix;
  }

  bool get isLookingForSolution {
    return _solutionInProgress;
  }
}

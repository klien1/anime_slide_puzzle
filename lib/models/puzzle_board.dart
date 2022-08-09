import 'dart:async';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/puzzle_solver/auto_solver.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
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
  bool _puzzleCompleted = false;

  // initializes puzzle with number of rows or columns
  PuzzleBoard({required numRowsOrColumns})
      : _numRowsOrColumns = numRowsOrColumns {
    resetBoard();
    // _puzzleTiles2d = _generatePuzzleMatrix(numRowsOrColumns);
    // _puzzleTileNumberMatrix = _generatePuzzleNumberMatrix(numRowsOrColumns);
    // List.generate(
    //     _numRowsOrColumns,
    //     (row) => List.generate(
    //         _numRowsOrColumns, (col) => row * _numRowsOrColumns + col,
    //         growable: false),
    //     growable: false);
  }

  // initializes puzzle board with 2d matrix
  PuzzleBoard.intBoard({required List<List<int>> board})
      : _numRowsOrColumns = board.length {
    _puzzleTiles2d = _generatePuzzleMatrix(numRowsOrColumns);
    for (int row = 0; row < board.length; ++row) {
      for (int col = 0; col < board.length; ++col) {
        Coordinate correctCoordinate = convert1dArrayCoordTo2dArrayCoord(
            index: board[row][col], numRowOrColCount: numRowsOrColumns);

        _puzzleTiles2d[correctCoordinate.row][correctCoordinate.col]
            .currentCoordinate = correctCoordinate;
      }
    }
    _puzzleTileNumberMatrix = board;
  }

  // solves the puzzle
  Future<void> autoSolve() async {
    _toggleSolutionInProgress(true);

    AutoSolver autoSolve = AutoSolver(puzzleBoard: this);
    await autoSolve.solve();

    _toggleSolutionInProgress(false);
  }

  List<List<int>> _generatePuzzleNumberMatrix(int numRowsOrCols) {
    return List.generate(
        _numRowsOrColumns,
        (row) => List.generate(
            _numRowsOrColumns, (col) => row * _numRowsOrColumns + col,
            growable: false),
        growable: false);
  }

  void resetBoard() {
    _puzzleTiles2d = _generatePuzzleMatrix(numRowsOrColumns);
    _puzzleTileNumberMatrix = _generatePuzzleNumberMatrix(numRowsOrColumns);
    _solutionInProgress = false;
    _gameInProgress = false;
    _puzzleCompleted = false;
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
    if (isOutOfBounds(matrix: matrix, curPoint: first) ||
        isOutOfBounds(matrix: matrix, curPoint: second)) {
      return false;
    }

    final int tempVal = matrix[first.row][first.col];
    matrix[first.row][first.col] = matrix[second.row][second.col];
    matrix[second.row][second.col] = tempVal;
    return true;
  }

  @visibleForTesting
  static bool isPuzzleIsSolvable({
    required List<List<int>> matrix,
    required int blankTileRow,
  }) {
    int numRowsOrColumns = matrix.length;
    int numInversions = countTotalInversion(matrix: matrix);

    if ((!isEven(num: numRowsOrColumns) && isEven(num: numInversions)) ||
        isEven(num: numRowsOrColumns) &&
            !isEven(num: numInversions + blankTileRow)) {
      return true;
    }
    return false;
  }

  void _toggleSolutionInProgress(bool status) {
    _solutionInProgress = status;
    notifyListeners();
  }

  void _toggleGameInProgress(bool status) {
    _gameInProgress = status;
    notifyListeners();
  }

  // moves tiles using tile correct coordinate and NOT current coordinate
  void moveTile({
    required Coordinate correctTileCoordinate,
  }) {
    if (isOutOfBounds(
      matrix: _puzzleTileNumberMatrix,
      curPoint: correctTileCoordinate,
    )) return;
    final PuzzleTile clickedTile =
        _puzzleTiles2d[correctTileCoordinate.row][correctTileCoordinate.col];

    final PuzzleTile blankTile = _puzzleTiles2d[_correctBlankTileCoordinate.row]
        [_correctBlankTileCoordinate.col];

    if (isAdjacentToEmptyTile(clickedTile.currentCoordinate)) {
      _swapTiles(clickedTile, blankTile);
      ++_numberOfMoves;

      if (_isPuzzleTileInCorrectPosition() && _gameInProgress) {
        _puzzleCompleted = true;
        _toggleGameInProgress(false);
      }

      notifyListeners();
    }
  }

  /// returns current position of given tile number
  Coordinate findCurrentTileNumberCoordiante(int tileNum) {
    Coordinate correctTileCoordiante = convert1dArrayCoordTo2dArrayCoord(
      index: tileNum,
      numRowOrColCount: _numRowsOrColumns,
    );
    Coordinate curTileCoordinate = _puzzleTiles2d[correctTileCoordiante.row]
            [correctTileCoordiante.col]
        .currentCoordinate;

    return curTileCoordinate;
  }

  bool isAdjacentToEmptyTile(Coordinate curTileCoordinate) {
    Coordinate curBlankPos = currentBlankTileCoordiante;

    return curTileCoordinate ==
            curBlankPos.calculateAdjacent(direction: Direction.right) ||
        curTileCoordinate ==
            curBlankPos.calculateAdjacent(direction: Direction.left) ||
        curTileCoordinate ==
            curBlankPos.calculateAdjacent(direction: Direction.bottom) ||
        curTileCoordinate ==
            curBlankPos.calculateAdjacent(direction: Direction.top);
  }

  void resetNumberOfMoves() {
    _numberOfMoves = 0;
  }

  void startGame() {
    resetNumberOfMoves();
    _gameInProgress = true;
    _puzzleCompleted = false;
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
    if (firstTile == secondTile ||
        isOutOfBounds(
          matrix: _puzzleTileNumberMatrix,
          curPoint: firstTile.currentCoordinate,
        ) ||
        isOutOfBounds(
          matrix: _puzzleTileNumberMatrix,
          curPoint: secondTile.currentCoordinate,
        )) {
      return;
    }

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

  bool get isPuzzleCompleted {
    return _puzzleCompleted;
  }

  List<List<int>> get puzzleTileNumberMatrix {
    return _puzzleTileNumberMatrix;
  }

  bool get isLookingForSolution {
    return _solutionInProgress;
  }
}

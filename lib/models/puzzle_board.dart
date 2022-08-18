import 'dart:async';
import 'dart:math';

import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/puzzle_solver/auto_solver.dart';
import 'package:anime_slide_puzzle/utils/puzzle_board_helper.dart';
import 'package:flutter/material.dart';

class PuzzleBoard extends ChangeNotifier {
  final int _numRowsOrColumns;
  late List<List<PuzzleTile>> _correctTileMatrix;
  late List<List<int>> _curPositionMatrix;
  int _numberOfMoves = 0;
  bool _gameInProgress = false;
  bool _solutionInProgress = false;
  bool _isPuzzleCompleted = false;
  bool _isShuffling = false;
  int _curCountdown = 0;

  // initializes puzzle with number of rows or columns
  PuzzleBoard({required numRowsOrColumns})
      : _numRowsOrColumns = numRowsOrColumns {
    resetBoard();
  }

  // initializes puzzle board with 2d matrix
  PuzzleBoard.intBoard({required List<List<int>> board})
      : _numRowsOrColumns = board.length {
    _curPositionMatrix = board;
    _correctTileMatrix = _generatePuzzleMatrix(numRowsOrColumns);
    for (int row = 0; row < board.length; ++row) {
      for (int col = 0; col < board.length; ++col) {
        final curTileNumber = board[row][col];
        final Coordinate correctCoordinate = findCorrectTileCoordinate(
          index: curTileNumber,
          numRowOrColCount: numRowsOrColumns,
        );
        _correctTileMatrix[correctCoordinate.row][correctCoordinate.col] =
            PuzzleTile(
          correctCoordinate: correctCoordinate,
          currentCoordinate: Coordinate(row: row, col: col),
          tileNumber: curTileNumber,
        );
      }
    }
  }

  // solves the puzzle
  Future<void> autoSolve() async {
    _toggleSolutionInProgress(true);

    AutoSolver autoSolve = AutoSolver(puzzleBoard: this);
    await autoSolve.solve();

    _toggleSolutionInProgress(false);
    _isPuzzleCompleted = false;
  }

  void resetBoard() {
    if (_solutionInProgress) {
      _solutionInProgress = false;
    } else {
      _curCountdown = 0;
      _numberOfMoves = 0;
      _gameInProgress = false;
      _isPuzzleCompleted = false;
      _correctTileMatrix = _generatePuzzleMatrix(numRowsOrColumns);
      _curPositionMatrix = _generateTileNumberMatrix(numRowsOrColumns);
    }
  }

  List<List<int>> _generateTileNumberMatrix(int numRowsOrCols) {
    return List.generate(
        _numRowsOrColumns,
        (row) => List.generate(
            _numRowsOrColumns, (col) => row * _numRowsOrColumns + col,
            growable: false),
        growable: false);
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
  bool swapPosMatrix({required Coordinate first, required Coordinate second}) {
    // check if coordinates are within boundary
    if (isOutOfBoundsMatrix(matrix: _curPositionMatrix, curPoint: first) ||
        isOutOfBoundsMatrix(matrix: _curPositionMatrix, curPoint: second)) {
      return false;
    }

    final int tempVal = _curPositionMatrix[first.row][first.col];
    _curPositionMatrix[first.row][first.col] =
        _curPositionMatrix[second.row][second.col];
    _curPositionMatrix[second.row][second.col] = tempVal;
    return true;
  }

  bool isPuzzleIsSolvable() {
    int numInversions = countTotalInversion(matrix: _curPositionMatrix);

    if ((!isEven(num: _numRowsOrColumns) && isEven(num: numInversions)) ||
        isEven(num: _numRowsOrColumns) &&
            !isEven(num: numInversions + currentBlankTileCoordiante.row)) {
      return true;
    }
    return false;
  }

  void _toggleSolutionInProgress(bool status) {
    _solutionInProgress = status;
    notifyListeners();
  }

  void moveTilesUsingCurrentCoordinates({required Coordinate curCoord}) {
    final int tileNum = _curPositionMatrix[curCoord.row][curCoord.col];
    final Coordinate correctPosition = findCorrectTileCoordinate(
      index: tileNum,
      numRowOrColCount: _numRowsOrColumns,
    );

    moveTile(correctTileCoordinate: correctPosition);
  }

  // moves tiles using tile correct coordinate and NOT current coordinate
  void moveTile({required Coordinate correctTileCoordinate}) {
    if (isOutOfBoundsMatrix(
      matrix: _curPositionMatrix,
      curPoint: correctTileCoordinate,
    )) return;
    final PuzzleTile clickedTile = _correctTileMatrix[correctTileCoordinate.row]
        [correctTileCoordinate.col];

    final PuzzleTile blankTile =
        _correctTileMatrix[_correctBlankTileCoordinate.row]
            [_correctBlankTileCoordinate.col];

    if (isAdjacentToEmptyTile(clickedTile.currentCoordinate)) {
      _swapTiles(clickedTile, blankTile);
      ++_numberOfMoves;

      if (_isPuzzleTileInCorrectPosition() && _gameInProgress) {
        _puzzleCompleted();
      }

      notifyListeners();
    }
  }

  void _puzzleCompleted() {
    _isPuzzleCompleted = true;
    _gameInProgress = false;
  }

  List<int> flattenPositionMatrix() {
    List<int> flatten = [];
    for (List<int> element in _curPositionMatrix) {
      flatten.addAll(element);
    }
    return flatten;
  }

  /// returns current position of given tile number
  Coordinate findCurrentTileCoordiante(int tileNum) {
    Coordinate correctCoord = findCorrectTileCoordinate(
      index: tileNum,
      numRowOrColCount: _numRowsOrColumns,
    );
    Coordinate curTileCoordinate = _correctTileMatrix[correctCoord.row]
            [correctCoord.col]
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

  Future<void> startGame(int countdown) async {
    _numberOfMoves = 0;
    _gameInProgress = true;
    _isPuzzleCompleted = false;
    _curCountdown = countdown;
    await timedShuffled();
  }

  Future<void> timedShuffled() async {
    try {
      toggleShuffle();
      while (_curCountdown > 0) {
        _shuffleBoard();
        await Future.delayed(const Duration(seconds: 1));
        --_curCountdown;
      }

      // delay isShuffling notification to display start message
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      toggleShuffle();
    } catch (e) {
      _curCountdown = 0;
    }
  }

  void _shuffleBoard() {
    notifyListeners();
    do {
      for (List<PuzzleTile> puzzleList in _correctTileMatrix) {
        for (PuzzleTile tile in puzzleList) {
          _swapTiles(tile, _getRandomTile());
        }
      }
    } while (!isPuzzleIsSolvable() || _isPuzzleTileInCorrectPosition());
    notifyListeners();
  }

  bool _isPuzzleTileInCorrectPosition() {
    for (List<PuzzleTile> puzzleList in _correctTileMatrix) {
      for (PuzzleTile tile in puzzleList) {
        if (tile.correctCoordinate != tile.currentCoordinate) return false;
      }
    }
    return true;
  }

  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    notifyListeners();
  }

  PuzzleTile _getRandomTile() {
    Random rng = Random();
    return _correctTileMatrix[rng.nextInt(_numRowsOrColumns)]
        [rng.nextInt(_numRowsOrColumns)];
  }

  void _swapTiles(PuzzleTile firstTile, PuzzleTile secondTile) {
    if (firstTile == secondTile ||
        isOutOfBoundsMatrix(
          matrix: _curPositionMatrix,
          curPoint: firstTile.currentCoordinate,
        ) ||
        isOutOfBoundsMatrix(
          matrix: _curPositionMatrix,
          curPoint: secondTile.currentCoordinate,
        )) {
      return;
    }

    final Coordinate temp = firstTile.currentCoordinate;

    int firstRow = firstTile.correctCoordinate.row;
    int firstCol = firstTile.correctCoordinate.col;

    // assign first tile
    _correctTileMatrix[firstRow][firstCol] = PuzzleTile(
      correctCoordinate: firstTile.correctCoordinate,
      currentCoordinate: secondTile.currentCoordinate,
      tileNumber: firstTile.tileNumber,
      isBlank: firstTile.isBlankTile,
    );

    // assign second tile
    int secondRow = secondTile.correctCoordinate.row;
    int secondCol = secondTile.correctCoordinate.col;
    _correctTileMatrix[secondRow][secondCol] = PuzzleTile(
      correctCoordinate: secondTile.correctCoordinate,
      currentCoordinate: temp,
      tileNumber: secondTile.tileNumber,
      isBlank: secondTile.isBlankTile,
    );

    swapPosMatrix(
      first: firstTile.currentCoordinate,
      second: secondTile.currentCoordinate,
    );
  }

  Coordinate get _correctBlankTileCoordinate {
    return _correctTileMatrix[_numRowsOrColumns - 1][_numRowsOrColumns - 1]
        .correctCoordinate;
  }

  Coordinate get currentBlankTileCoordiante {
    return _correctTileMatrix[_numRowsOrColumns - 1][_numRowsOrColumns - 1]
        .currentCoordinate;
  }

  int get numRowsOrColumns {
    return _numRowsOrColumns;
  }

  List<List<PuzzleTile>> get correctTileMatrix {
    return _correctTileMatrix;
  }

  int get numberOfMoves {
    return _numberOfMoves;
  }

  bool get isGameInProgress {
    return _gameInProgress;
  }

  bool get isPuzzleCompleted {
    return _isPuzzleCompleted;
  }

  List<List<int>> get curPositionMatrix {
    return _curPositionMatrix;
  }

  bool get isLookingForSolution {
    return _solutionInProgress;
  }

  int get blankTileNumber {
    return _numRowsOrColumns * _numRowsOrColumns - 1;
  }

  bool get isShuffling {
    return _isShuffling;
  }

  int get curCountdown {
    return _curCountdown;
  }
}

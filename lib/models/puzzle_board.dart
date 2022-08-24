import 'dart:async';
import 'dart:math';

import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/utils/puzzle_solver/auto_solver.dart';
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
      : assert(numRowsOrColumns > 1),
        _numRowsOrColumns = numRowsOrColumns {
    resetBoard();
  }

  // initializes puzzle board with 2d matrix
  PuzzleBoard.intBoard({required List<List<int>> board})
      : assert(board.length > 1),
        _numRowsOrColumns = board.length {
    _curPositionMatrix = board;
    _correctTileMatrix = _generatePuzzleMatrix(numRowsOrColumns);
    for (int row = 0; row < board.length; ++row) {
      for (int col = 0; col < board.length; ++col) {
        final curTileNumber = board[row][col];
        final Coordinate correctCoordinate = findCorrectTileCoordinate(
          index: curTileNumber,
          numRowsOrColumns: numRowsOrColumns,
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
    try {
      _solutionInProgress = true;
      notifyListeners();

      AutoSolver autoSolve = AutoSolver(puzzleBoard: this);
      await autoSolve.solve();

      _solutionInProgress = false;
      _isPuzzleCompleted = false;
      notifyListeners();
    } catch (e) {
      // puzzle board destroyed
    }
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

  // generates a matrix with tiles current position
  List<List<int>> _generateTileNumberMatrix(int numRowsOrCols) {
    return List.generate(
        _numRowsOrColumns,
        (row) => List.generate(
            _numRowsOrColumns, (col) => row * _numRowsOrColumns + col,
            growable: false),
        growable: false);
  }

  // generates a matrix with the tiles correct posiion for animation
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
  @visibleForTesting
  bool swapPosMatrix({required Coordinate first, required Coordinate second}) {
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

  // checks to see if the puzzle can be solved
  @visibleForTesting
  bool isPuzzleIsSolvable() {
    int numInversions = countTotalInversion(matrix: _curPositionMatrix);

    // puzzle is solvable if
    // - board size is odd and number of inversions is even
    // - board size is even and number of inversions + blank tile row is odd
    if ((!isEven(num: _numRowsOrColumns) && isEven(num: numInversions)) ||
        isEven(num: _numRowsOrColumns) &&
            !isEven(num: numInversions + currentBlankTileCoordiante.row)) {
      return true;
    }
    return false;
  }

  void moveTilesUsingCurrentCoordinates({required Coordinate curCoord}) {
    final int tileNum = _curPositionMatrix[curCoord.row][curCoord.col];
    final Coordinate correctPosition = findCorrectTileCoordinate(
      index: tileNum,
      numRowsOrColumns: _numRowsOrColumns,
    );
    moveTileUsingCorrectCoordinate(correctCoord: correctPosition);
  }

  // moves tiles using correct tile coordinate and NOT current tile coordinate
  void moveTileUsingCorrectCoordinate({required Coordinate correctCoord}) {
    if (isOutOfBoundsMatrix(
      matrix: _curPositionMatrix,
      curPoint: correctCoord,
    )) return;

    final PuzzleTile clickedTile =
        _correctTileMatrix[correctCoord.row][correctCoord.col];

    if (!isAdjacentToEmptyTile(clickedTile.currentCoordinate)) return;

    final PuzzleTile blankTile =
        _correctTileMatrix[_correctBlankTileCoordinate.row]
            [_correctBlankTileCoordinate.col];

    _swapTiles(clickedTile, blankTile);
    ++_numberOfMoves;

    if (_isPuzzleTileInCorrectPosition() && _gameInProgress) {
      _isPuzzleCompleted = true;
      _gameInProgress = false;
    }

    notifyListeners();
  }

  // flattens matrix into 1-dimensional array to solve puzzle
  List<int> flattenCorrectPositionMatrix() {
    List<int> flattenMatrix = [];
    for (List<int> element in _curPositionMatrix) {
      flattenMatrix.addAll(element);
    }
    return flattenMatrix;
  }

  /// returns current position of given tile number
  Coordinate findCurrentTileCoordiante(int tileNum) {
    Coordinate correctCoord = findCorrectTileCoordinate(
      index: tileNum,
      numRowsOrColumns: _numRowsOrColumns,
    );
    Coordinate currentTileCoordinate = _correctTileMatrix[correctCoord.row]
            [correctCoord.col]
        .currentCoordinate;

    return currentTileCoordinate;
  }

  // checks to see if current coordinate is adjacent to blank tile
  bool isAdjacentToEmptyTile(Coordinate curCoord) {
    Coordinate blankPos = currentBlankTileCoordiante;

    return curCoord == blankPos.calculateAdjacent(direction: Direction.right) ||
        curCoord == blankPos.calculateAdjacent(direction: Direction.left) ||
        curCoord == blankPos.calculateAdjacent(direction: Direction.bottom) ||
        curCoord == blankPos.calculateAdjacent(direction: Direction.top);
  }

  // initializes gameboard and shuffles the board
  Future<void> startGame(int countdown) async {
    _gameInProgress = false;
    notifyListeners();
    _numberOfMoves = 0;
    _isPuzzleCompleted = false;
    await timedShuffled(countdown);
  }

  // shuffles the game board counting down from initialCountdown
  Future<void> timedShuffled(int initialCountdown) async {
    _curCountdown = initialCountdown;
    try {
      _isShuffling = !_isShuffling;
      notifyListeners();
      while (_curCountdown > 0) {
        _shuffleBoard();
        await Future.delayed(const Duration(seconds: 1));
        --_curCountdown;
      }

      // delay isShuffling notification to display message before game starts
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      _isShuffling = !_isShuffling;
      _gameInProgress = true;
      notifyListeners();
    } catch (e) {
      _curCountdown = 0;
    }
  }

  // shuffles the game board until board is solvable and not in the starting position
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

  // checks if all tiles are in the correct position
  bool _isPuzzleTileInCorrectPosition() {
    for (List<PuzzleTile> puzzleList in _correctTileMatrix) {
      for (PuzzleTile tile in puzzleList) {
        if (tile.correctCoordinate != tile.currentCoordinate) return false;
      }
    }
    return true;
  }

  // randomly selects a puzzle tile
  PuzzleTile _getRandomTile() {
    Random rng = Random();
    int randomRow = rng.nextInt(_numRowsOrColumns);
    int randomCol = rng.nextInt(_numRowsOrColumns);
    return _correctTileMatrix[randomRow][randomCol];
  }

  // swap two tile's current position
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

    // assign first tile
    int firstRow = firstTile.correctCoordinate.row;
    int firstCol = firstTile.correctCoordinate.col;

    _correctTileMatrix[firstRow][firstCol] = _correctTileMatrix[firstRow]
            [firstCol]
        .copyWith(currentCoordinate: secondTile.currentCoordinate);

    // assign second tile
    int secondRow = secondTile.correctCoordinate.row;
    int secondCol = secondTile.correctCoordinate.col;

    _correctTileMatrix[secondRow][secondCol] = _correctTileMatrix[secondRow]
            [secondCol]
        .copyWith(currentCoordinate: temp);

    swapPosMatrix(
      first: firstTile.currentCoordinate,
      second: secondTile.currentCoordinate,
    );
  }

  Coordinate get _correctBlankTileCoordinate {
    final PuzzleTile blankTile =
        _correctTileMatrix[_numRowsOrColumns - 1][_numRowsOrColumns - 1];
    return blankTile.correctCoordinate;
  }

  Coordinate get currentBlankTileCoordiante {
    final PuzzleTile blankTile =
        _correctTileMatrix[_numRowsOrColumns - 1][_numRowsOrColumns - 1];
    return blankTile.currentCoordinate;
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

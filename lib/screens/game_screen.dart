import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/components/game_image_selector.dart';
import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';

const double gameWidth = 500;
const double gameHeight = 500;
const double padding = 5;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PuzzleImageSelector _puzzleImageSelector;
  bool isLoadingImages = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _puzzleImageSelector = context.watch<PuzzleImageSelector>();
    _puzzleImageSelector.loadImages();
    setState(() {
      isLoadingImages = _puzzleImageSelector.isLoadingImage;
    });
  }

  void calculateRatio() {
    final double imageW = _puzzleImageSelector.currentImage.width;
    final double imageH = _puzzleImageSelector.currentImage.height;
    final double maxW = MediaQuery.of(context).size.width * .7;
    final double maxH = MediaQuery.of(context).size.height * .7;

    final double wRatio = maxW / imageW;
    final double hRatio = maxH / imageH;

    final double best = min(wRatio, hRatio);

    final double width = imageW * best;
    final double height = imageH * best;
  }

  @override
  Widget build(BuildContext context) {
    final myProviders = [
      ChangeNotifierProvider<NumberPuzzleTiles>(
        create: (BuildContext context) => NumberPuzzleTiles(),
      ),
      ChangeNotifierProxyProvider<NumberPuzzleTiles, PuzzleBoard>(
        create: (BuildContext context) => PuzzleBoard(
          numRowsOrColumns:
              Provider.of<NumberPuzzleTiles>(context, listen: false)
                  .currentNumberOfTiles,
        ),
        update: ((context, value, previous) =>
            PuzzleBoard(numRowsOrColumns: value.currentNumberOfTiles)),
      ),
    ];

    return MultiProvider(
      providers: myProviders,
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const GameImageSelector(),
              Column(
                children: [
                  const SelectBoardSize(),
                  GameBoard(
                    width: gameWidth,
                    height: gameHeight,
                    // width: (!isLoadingImages) ? width : gameWidth,
                    // height: (!isLoadingImages) ? height : gameHeight,
                    tilePadding: padding,
                  ),
                ],
              ),
              const GameButtonControls(),
            ],
          ),
        ),
      ),
    );
  }
}

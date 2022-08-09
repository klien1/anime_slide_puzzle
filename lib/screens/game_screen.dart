import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_status.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';
import 'dart:math';

// const double gameWidth = 250;
// const double gameHeight = 250;
const double gameWidth = 500;
const double gameHeight = 500;
const double padding = 3;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool waitForImage = true;
  bool showPuzzle = false;

  GameTimer? gameTimer;
  PuzzleBoard? puzzleBoard;

  @override
  void initState() {
    super.initState();

    delayedBackgroundAnimation();
    delayedPuzzleAnimation();
  }

  Future<void> delayedBackgroundAnimation() async {
    await Future.delayed(const Duration(microseconds: 100));
    setState(() {
      waitForImage = false;
    });
  }

  Future<void> delayedPuzzleAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    setState(() {
      showPuzzle = true;
    });
  }

  @override
  void didChangeDependencies() {
    // context.read<GameTimer>()
    //   ..resetTimer()
    //   ..endTimer();
    // context.read<PuzzleBoard>()
    //   ..resetNumberOfMoves()
    //   ..resetBoard();
    super.didChangeDependencies();
    gameTimer = context.read<GameTimer>();
    puzzleBoard = context.read<PuzzleBoard>();
  }

  @override
  void dispose() {
    gameTimer
      ?..resetTimer()
      ..endTimer();
    puzzleBoard
      ?..resetNumberOfMoves()
      ..resetBoard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    AnimeTheme animeTheme = animeThemeList.curAnimeTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Transform(
              transform: Matrix4.rotationY(pi),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: (waitForImage)
                    ? BackgroundImage(
                        key: const Key('character-background'),
                        imagePath: animeTheme.backgroundImagePath,
                        backgroundColor: animeTheme.backgroundColor,
                      )
                    : BackgroundImage(
                        key: const Key('background'),
                        imagePath: animeTheme.puzzleBackgroundImagePath,
                        backgroundColor: animeTheme.backgroundColor,
                      ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Back',
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(10),
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () => Navigator.pop(context),
              //   child: const Padding(
              //     padding: EdgeInsets.only(bottom: 4, right: 2),
              //     child: Text.rich(
              //       TextSpan(
              //         style: TextStyle(fontSize: 20),
              //         children: [
              //           WidgetSpan(child: Icon(Icons.arrow_back)),
              //           TextSpan(text: 'Back'),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      // height: 200,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Hero(
                        tag: animeTheme.name,
                        //'anime_photo${animeTheme.index}',
                        child: Image(
                          image: AssetImage(animeTheme.logoImagePath),
                        ),
                      ),
                    ),
                    const GameStatus(),
                    const GameButtonControls(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: (showPuzzle) ? 1 : 0,
                      child: Column(
                        children: [
                          // const GameStatus(),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const GameBoard(
                              width: gameWidth,
                              height: gameHeight,
                              tilePadding: padding,
                            ),
                          ),
                          // const GameButtonControls(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

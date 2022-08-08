import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/game_status.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';
import 'dart:math';

// const double gameWidth = 250;
// const double gameHeight = 250;
const double gameWidth = 600;
const double gameHeight = 600;
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
              // child: BackgroundImage(
              //   key: const Key('character-background'),
              //   imagePath: animeTheme.puzzleBackgroundImagePath,
              //   backgroundColor: animeTheme.backgroundColor,
              // )
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
            Container(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
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
                        tag: 'anime_photo${animeTheme.index}',
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

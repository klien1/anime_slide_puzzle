import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/custom_back_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_status.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/screens/congratulations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';

class GameBoardLayoutMedium extends StatefulWidget {
  const GameBoardLayoutMedium({
    Key? key,
    required this.puzzleWidth,
    required this.puzzleHeight,
    required this.puzzlePadding,
  }) : super(key: key);

  static const String id = 'game_screen_id';
  final double puzzleWidth;
  final double puzzleHeight;
  final double puzzlePadding;

  @override
  State<GameBoardLayoutMedium> createState() => _GameBoardLayoutMedium();
}

class _GameBoardLayoutMedium extends State<GameBoardLayoutMedium> {
  bool showPuzzle = false;

  GameTimer? gameTimer;
  PuzzleBoard? puzzleBoard;

  @override
  void initState() {
    super.initState();
    delayShowPuzzleAnimation();
  }

  Future<void> delayShowPuzzleAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    setState(() => showPuzzle = true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    gameTimer = context.read<GameTimer>();
    puzzleBoard = context.read<PuzzleBoard>();
    precacheImage(
      AssetImage(context.read<AnimeThemeList>().curPuzzleBackground!),
      context,
    );
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
      body: Selector<PuzzleBoard, bool>(
        selector: (context, completedPuzzleBoard) =>
            completedPuzzleBoard.isPuzzleCompleted,
        builder: ((context, puzzleCompleted, child) {
          if (puzzleCompleted) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (context) => const Congratulations(),
              );
            });
          }
          return Stack(
            children: [
              BackgroundImage(imagePath: animeTheme.puzzleBackgroundImagePath),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CustomBackButton(),
                            GameButtonControls(
                              spaceBetween: 0,
                              alignRow: false,
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedHeroImage(
                            animeTheme: animeTheme,
                            width: 150,
                            height: 150,
                          ),
                          const GameStatus(),
                          // const GameButtonControls(),
                        ],
                      ),
                    ),
                    GameBoard(
                      width: widget.puzzleWidth,
                      height: widget.puzzleHeight,
                      tilePadding: widget.puzzlePadding,
                      showPuzzle: showPuzzle,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class SizedHeroImage extends StatelessWidget {
  const SizedHeroImage(
      {Key? key, required this.animeTheme, this.height, this.width})
      : super(key: key);

  final AnimeTheme animeTheme;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Hero(
        tag: animeTheme.name,
        child: Image(
          image: AssetImage(animeTheme.logoImagePath),
        ),
      ),
    );
  }
}

// import 'package:anime_slide_puzzle/components/background_image.dart';
// import 'package:anime_slide_puzzle/components/custom_back_button.dart';
// import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_status.dart';
// import 'package:anime_slide_puzzle/models/anime_theme.dart';
// import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
// import 'package:anime_slide_puzzle/models/game_timer.dart';
// import 'package:anime_slide_puzzle/models/puzzle_board.dart';
// import 'package:anime_slide_puzzle/screens/congratulations.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
// import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';
//
// // const double gameWidth = 250;
// // const double gameHeight = 250;
// const double gameWidth = 500;
// const double gameHeight = 500;
// const double padding = 5;
//
// class GameScreen extends StatefulWidget {
//   const GameScreen({Key? key}) : super(key: key);
//
//   static const String id = 'game_screen_id';
//
//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }
//
// class _GameScreenState extends State<GameScreen> {
//   bool showPuzzle = false;
//
//   GameTimer? gameTimer;
//   PuzzleBoard? puzzleBoard;
//
//   @override
//   void initState() {
//     super.initState();
//     delayShowPuzzleAnimation();
//   }
//
//   Future<void> delayShowPuzzleAnimation() async {
//     await Future.delayed(const Duration(milliseconds: 1100));
//     setState(() => showPuzzle = true);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     gameTimer = context.read<GameTimer>();
//     puzzleBoard = context.read<PuzzleBoard>();
//     precacheImage(
//       AssetImage(context.read<AnimeThemeList>().curPuzzleBackground!),
//       context,
//     );
//   }
//
//   @override
//   void dispose() {
//     gameTimer
//       ?..resetTimer()
//       ..endTimer();
//     puzzleBoard
//       ?..resetNumberOfMoves()
//       ..resetBoard();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
//     AnimeTheme animeTheme = animeThemeList.curAnimeTheme;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Selector<PuzzleBoard, bool>(
//           selector: (context, completedPuzzleBoard) =>
//               completedPuzzleBoard.isPuzzleCompleted,
//           builder: ((context, puzzleCompleted, child) {
//             if (puzzleCompleted) {
//               Future.delayed(Duration.zero, () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => const Congratulations(),
//                 );
//               });
//             }
//             return Stack(
//               children: [
//                 BackgroundImage(
//                     imagePath: animeTheme.puzzleBackgroundImagePath),
//                 const CustomBackButton(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedHeroImage(animeTheme: animeTheme),
//                         const GameStatus(),
//                         const GameButtonControls(),
//                       ],
//                     ),
//                     GameBoard(
//                       width: gameWidth,
//                       height: gameHeight,
//                       tilePadding: padding,
//                       showPuzzle: showPuzzle,
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
//
// class SizedHeroImage extends StatelessWidget {
//   const SizedHeroImage(
//       {Key? key, required this.animeTheme, this.height, this.width})
//       : super(key: key);
//
//   final AnimeTheme animeTheme;
//   final double? height;
//   final double? width;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: MediaQuery.of(context).size.width * 0.3,
//       child: Hero(
//         tag: animeTheme.name,
//         child: Image(
//           image: AssetImage(animeTheme.logoImagePath),
//         ),
//       ),
//     );
//   }
// }
//

import 'package:anime_slide_puzzle/components/game_board/game_board_layout_large.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout_medium.dart';
import 'package:anime_slide_puzzle/constants.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static String id = 'game_screen_id';
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < small) {
        return Container(
          child: Text('Small'),
        );
      } else if (constraints.maxWidth < medium) {
        return const GameBoardLayoutMedium(
          puzzleWidth: 300,
          puzzleHeight: 300,
          puzzlePadding: 5,
        );
      } else if (constraints.maxWidth < large) {
        return const GameBoardLayoutLarge(
          puzzleWidth: 600,
          puzzleHeight: 600,
          puzzlePadding: 5,
        );
      } else {
        return Container();
      }
    });
  }
}

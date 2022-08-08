import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';

const int kMaxNumberOfTiles = 5;
const Duration kPageTransitionDuration = Duration(seconds: 2);

class SelectBoardSize extends StatelessWidget {
  const SelectBoardSize({Key? key}) : super(key: key);

  List<Widget> getNumberSelectorWidget(int numRowsOrCol, BuildContext context) {
    List<Widget> widgetList = [];
    NumberPuzzleTiles selector = context.watch<NumberPuzzleTiles>();

    for (int numTiles = 3; numTiles <= numRowsOrCol; ++numTiles) {
      widgetList.add(
        ElevatedButton(
          onPressed: (context.read<PuzzleBoard>().isLookingForSolution)
              ? null
              : (selector.currentNumberOfTiles == numTiles)
                  ? null
                  : () => selector.changeNumberOfTiles(numTiles),
          child: Text('${numTiles}x$numTiles'),
        ),
      );
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getNumberSelectorWidget(kMaxNumberOfTiles, context),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: kPageTransitionDuration,
                pageBuilder: (_, __, ___) => const GameScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  double beginRadius = 0.0;
                  // double endRadius = MediaQuery.of(context).size.width * 3;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  double endRadius = (screenWidth > screenHeight)
                      ? screenWidth * 1.3
                      : screenHeight * 1.3;

                  var radiusTween = Tween(begin: beginRadius, end: endRadius);
                  var radiusTweenAnimation = animation.drive(radiusTween);

                  return ClipPath(
                    clipper: CircleTransitionClipper(
                      center: Offset(0, 0),
                      radius: radiusTweenAnimation.value,
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Text('Start Puzzle'),
        )
      ],
    );
  }
}

class CircleTransitionClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircleTransitionClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
        center: center,
        radius: radius,
      ));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

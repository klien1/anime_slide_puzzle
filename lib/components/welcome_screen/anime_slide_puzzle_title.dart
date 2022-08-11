import 'package:anime_slide_puzzle/constants.dart';
import 'package:flutter/material.dart';

class AnimeSlidePuzzleTitle extends StatelessWidget {
  const AnimeSlidePuzzleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Align(
          child: Text(
            'Anime',
            style: titleStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text(
            'Slide',
            style: titleStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 150),
          child: Text(
            'Puzzle',
            style: titleStyle,
          ),
        ),
      ],
    );
  }
}

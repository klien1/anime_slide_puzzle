import 'package:anime_slide_puzzle/components/game_board/bordered_text.dart';
import 'package:flutter/material.dart';

const myStyle = TextStyle(fontSize: 70);

class AnimeSlidePuzzleTitle extends StatelessWidget {
  const AnimeSlidePuzzleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        // BorderedText(
        //     text: 'Anime',
        //     strokeWidth: 1,
        //     strokeColor: Colors.white,
        //     textColor: Colors.black),
        // // BorderedText('Anime'),
        Text(
          'Anime',
          style: myStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            'Slide',
            style: myStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 100),
          child: Text(
            'Puzzle',
            style: myStyle,
          ),
        ),
      ],
    );
  }
}

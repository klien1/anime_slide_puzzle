import 'package:flutter/material.dart';

const myStyle = TextStyle(
  fontSize: 70,
  color: Color(0xFF1b1d29),
);

class AnimeSlidePuzzleTitle extends StatelessWidget {
  const AnimeSlidePuzzleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Align(
          // alignment: Alignment.centerLeft,
          child: Text(
            'Anime',
            style: myStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text(
            'Slide',
            style: myStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 150),
          child: Text(
            'Puzzle',
            style: myStyle,
          ),
        ),
      ],
    );
  }
}

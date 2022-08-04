import 'package:flutter/material.dart';

class ImagelessPuzzle extends StatelessWidget {
  const ImagelessPuzzle({
    Key? key,
    required this.width,
    required this.height,
    required this.isBlankTile,
    required this.tileNumber,
  }) : super(key: key);

  final double width;
  final double height;
  final bool isBlankTile;
  final int tileNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            isBlankTile ? Colors.lightBlue.withOpacity(0.0) : Colors.lightBlue,
      ),
      child: Center(
        child: Text(
          (tileNumber + 1).toString(),
          style: TextStyle(
            fontFamily: 'Bangers',
            color: isBlankTile ? Colors.black.withOpacity(0.0) : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

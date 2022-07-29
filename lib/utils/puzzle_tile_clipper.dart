import 'package:flutter/material.dart';

class PuzzleTileClipper extends CustomClipper<Path> {
  final int curRow;
  final int curCol;
  final double tileDimension;

  PuzzleTileClipper({
    required this.curRow,
    required this.curCol,
    required this.tileDimension,
  });

  @override
  Path getClip(Size size) {
    // print('width: ${size.width}, height: ${size.height}');
    return _squareClipper(size, curRow, curCol, tileDimension);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  Path _squareClipper(Size size, int curRow, int curCol, double tileDimension) {
    // Path path = Path();

    // final double startingXPosition = tileDimension * curRow;
    // final double startingYPosition = tileDimension * curCol;
    // final rowWidth = size.width / 3;
    // final colWidth = size.height / 3;

    // print('$size, $startingXPosition, $startingYPosition, $tileDimension');

    // // top left
    // path.moveTo(startingXPosition, startingYPosition);

    // // top right
    // path.lineTo(startingXPosition, startingYPosition + tileDimension);

    // // bottom right
    // path.lineTo(
    //     startingXPosition + tileDimension, startingYPosition + tileDimension);

    // // bottom left
    // path.lineTo(startingXPosition + tileDimension, startingYPosition);

    final width = size.width / 3;
    final height = size.height / 3;
    final offsetX = curCol * width;
    final offsetY = curRow * height;

    print('$size, $width, $height, $tileDimension');

    var path = Path();

    path.moveTo(offsetX, offsetY);
    path.lineTo(offsetX + width, offsetY);
    path.lineTo(offsetX + width, offsetY + height);
    path.lineTo(offsetX, offsetY + height);

    path.close();
    return path;
  }
}

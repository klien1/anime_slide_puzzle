import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/utils/image_helper.dart';

class CreatePuzzlePiece extends StatefulWidget {
  const CreatePuzzlePiece({Key? key}) : super(key: key);

  @override
  State<CreatePuzzlePiece> createState() => _CreatePuzzlePieceState();
}

class _CreatePuzzlePieceState extends State<CreatePuzzlePiece> {
  final Image fullImage =
      const Image(image: AssetImage('images/spy-x-family.webp'));
  late final ImageDimension spyImage;

  void clip() async {
    spyImage = await getImageDimension(fullImage);
  }

  Widget test() {
    PuzzleClipper puzzleClipper = PuzzleClipper(0, 0, 300, 300);
    var dim = 166;

    var numRow = 4;
    var numCol = 4;

    return Stack(
      children: [
        for (int row = 0; row < numRow; ++row)
          for (int col = 0; col < numCol; ++col)
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              child: ClipPath(
                clipper: PuzzleClipper(row, col, numRow, numCol),
                child: fullImage,
              ),
            ),
        // AnimatedPositioned(
        //   duration: Duration(milliseconds: 200),
        //   child: ClipPath(clipper: PuzzleClipper(2, 2, 3, 3), child: fullImage),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return test();
  }
}

class PuzzleClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzleClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    return getPiecePath(size, row, col, maxRow, maxCol);
    //throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
    // throw UnimplementedError();
  }

  Path getPiecePath(Size size, int row, int col, int numRow, int numCol) {
    // col = (col == 0) ? 1 : col;
    // row = (row == 0) ? 1 : col;

    final width = size.width / numCol;
    final height = size.height / numRow;
    final offsetX = col * width;
    final offsetY = row * height;

    var path = Path();

    // path
    // var tileDimension = 166;

    // path.moveTo(0, 0);
    // path.lineTo(0, 166);
    // path.lineTo(166, 166);
    // path.lineTo(166, 0);

    path.moveTo(offsetX, offsetY);
    path.lineTo(offsetX + width, offsetY);
    path.lineTo(offsetX + width, offsetY + height);
    path.lineTo(offsetX, offsetY + height);
    path.close();

    return path;
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

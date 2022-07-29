import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/utils/image_helper.dart';

class TransformTest extends StatefulWidget {
  TransformTest({Key? key}) : super(key: key);

  @override
  State<TransformTest> createState() => _TransformTestState();
}

class _TransformTestState extends State<TransformTest> {
  late ImageDimension imageDimension;

  @override
  void initState() {
    super.initState();
    getImageDim();
  }

  void getImageDim() async {
    imageDimension = await getImageDimension(
      const Image(
        image: AssetImage('images/spy-x-family.webp'),
      ),
    );

    // print(imageDimension.width);
    // print(imageDimension.width);
  }

  @override
  Widget build(BuildContext context) {
    String curImage = context.watch<PuzzleImageChanger>().curImagePath;
    // Offset originOffset = Offset(300, 300);

    final double heightAndWidth = 300;
    final int numTilesPerRowOrColumn = 5;

    double topLeft = -heightAndWidth / 2;
    double topRight = -heightAndWidth / 2;

    double move = heightAndWidth / (numTilesPerRowOrColumn - 1);
    print(move);

    for (int i = 0; i < numTilesPerRowOrColumn; ++i) {
      double m = topLeft + move * i;
      Offset originOffset = Offset(m, topRight);
      print(m);
    }

    // Offset originOffset2 = Offset(topLeft + move, topRight);
    // print(topLeft + move);
    // Offset originOffset3 = Offset(topLeft + move * 2, topRight);
    // print(topLeft + move + move);
    // originOffset = Offset(topLeft + move + move, topRight);

    // top left
    //Offset(-250, -137);

    // top right
    // Offset(250, -137)

    // bottom left
    //Offset(-250, 137);

    // bottom right
    // Offset(250, 137)

    return Row(
      children: [
        for (int i = 0; i < numTilesPerRowOrColumn; ++i)
          square(
            heightAndWidth,
            Offset(topLeft, topRight + move * i),
            curImage,
            numTilesPerRowOrColumn.toDouble(),
          ),
      ],
    );
  }

  Container square(double heightAndWidth, Offset originOffset, String curImage,
      double scale) {
    return Container(
      height: heightAndWidth,
      width: heightAndWidth,
      child: ClipRect(
        child: OverflowBox(
          child: Transform.scale(
            scale: scale,
            origin: originOffset,
            child: SizedBox(
              width: double.minPositive,
              height: double.minPositive,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage(curImage),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

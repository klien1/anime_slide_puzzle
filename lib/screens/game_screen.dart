import 'package:flutter/material.dart';
import 'animated_slide_test.dart';

const double rectHeight = 100;
const double rectWidth = 100;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        // child: RectGrid(),
        child: SlideTest(),
      ),
    );
  }
}

class RectGrid extends StatefulWidget {
  const RectGrid({Key? key}) : super(key: key);

  @override
  State<RectGrid> createState() => _RectGridState();
}

class _RectGridState extends State<RectGrid> {
  List<Alignment> align = [];

  int curBox = 0;
  late List<Widget> gridList;

  List<Widget> simpleGridList() {
    return [
      AnimatedAlign(
        alignment: Alignment.center,
        duration: Duration(seconds: 1),
        child: CustomRectangle(
          num: 0,
          onTap: () {},
          color: Colors.red,
        ),
      ),
      AnimatedAlign(
        alignment: Alignment.center,
        duration: Duration(seconds: 1),
        child: CustomRectangle(
          num: 1,
          onTap: () {},
          color: Colors.green,
        ),
      ),
      AnimatedAlign(
        alignment: Alignment.center,
        duration: Duration(seconds: 1),
        child: CustomRectangle(
          num: 2,
          onTap: () {},
          color: Colors.blue,
        ),
      ),
    ];
  }

  List<Widget> getGridList() {
    print('called grid lsit');
    List<Widget> list = [];

    for (int i = 0; i < 8; ++i) {
      CustomRectangle curRec = CustomRectangle(
          num: i,
          onTap: () {
            setState(() {
              curBox = i;
            });
          });
      // align.add(const Alignment(0, 0));
      list.add(
        AnimatedAlign(
            alignment: align[i],
            duration: const Duration(milliseconds: 500),
            child: curRec),
      );
    }

    return list;
  }

  Widget generateButton(String text, double x, double y) {
    return TextButton(
        onPressed: () {
          setState(() {
            double curX = align[curBox].x;
            double curY = align[curBox].y;

            // double newX = curX / (rectWidth / 2) + x * rectWidth;
            double newX = curX + x;
            double newY = curY / (rectHeight / 2) + y;
            align[curBox] = Alignment(newX, newY);
            // gridList[curBox] = align[curBox];
          });
        },
        child: Text(text));
  }

  Widget changeBoxButton(int num) {
    return TextButton(
      onPressed: () {
        setState(() {
          curBox = num;
        });
      },
      child: Text(num.toString()),
    );
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 8; ++i) {
      align.add(const Alignment(0, 0));
    }
    gridList = simpleGridList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'selected box: ${curBox.toString()}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
        Expanded(
          // flex: 2,

          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            // mainAxisSpacing: 1,
            // crossAxisSpacing: 1,
            children: gridList,
            //children: getGridList(),
          ),
        ),
        TextButton(
            onPressed: () {
              setState(() {
                gridList = [gridList[2], gridList[1], gridList[0]];
                // var temp = gridList[0];
                // gridList[0] = gridList[1];
                // gridList[1] = temp;
              });
            },
            child: Text('Swap 0 and 2')),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generateButton('left', -3, 0),
            generateButton('right', 3, 0),
            generateButton('down', 0, 3),
            generateButton('up', 0, -3)
          ],
        )
      ],
    );
  }
}

class CustomRectangle extends StatefulWidget {
  const CustomRectangle({
    Key? key,
    this.color = Colors.lightBlueAccent,
    required this.num,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final int num;
  final Function onTap;

  @override
  State<CustomRectangle> createState() => _CustomRectangleState();
}

class _CustomRectangleState extends State<CustomRectangle> {
  bool onHover = false;

  get boxIndex {
    return widget.num;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: MouseRegion(
        onEnter: (v) {
          setState(() {
            onHover = true;
          });
        },
        onExit: (v) {
          setState(() {
            onHover = false;
          });
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: onHover ? .85 : 1,
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            height: rectHeight,
            width: rectWidth,
            color: widget.color,
            child: Center(
              child: Text(
                widget.num.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

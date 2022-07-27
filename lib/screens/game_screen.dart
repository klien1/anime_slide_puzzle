import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: RectGrid(),
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

  List<Widget> getGridList() {
    List<Widget> list = [];

    for (int i = 0; i < 8; ++i) {
      CustomRectangle curRec = CustomRectangle(
          num: i,
          onTap: () {
            setState(() {
              curBox = i;
            });
            print(i);
          });
      // align.add(const Alignment(0, 0));
      list.add(AnimatedAlign(
          alignment: align[i],
          duration: const Duration(milliseconds: 500),
          child: curRec));
    }

    return list;
  }

  Widget generateButton(String text, double x, double y) {
    return TextButton(
        onPressed: () {
          setState(() {
            double curX = align[curBox].x;
            double curY = align[curBox].y;
            align[curBox] = Alignment(curX + 1 * x, curY + 1 * y);
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
    // gridList = getGridList();
    for (int i = 0; i < 8; ++i) {
      align.add(Alignment(0, 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'selected box: ${curBox.toString()}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: getGridList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generateButton('left', -1, 0),
            generateButton('right', 1, 0),
            generateButton('down', 0, 1),
            generateButton('up', 0, -1)
          ],
        )
      ],
    );
  }
}

class AnimatedAlignWrapper extends StatefulWidget {
  const AnimatedAlignWrapper(
      {Key? key,
      required this.alignment,
      required this.duration,
      required this.child})
      : super(key: key);

  final AlignmentGeometry alignment;
  final Duration duration;
  final Widget child;

  @override
  State<AnimatedAlignWrapper> createState() => _AnimatedAlignWrapperState();
}

class _AnimatedAlignWrapperState extends State<AnimatedAlignWrapper> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
        alignment: widget.alignment,
        duration: widget.duration,
        child: widget.child);
  }
}

class CustomRectangle extends StatelessWidget {
  const CustomRectangle({
    Key? key,
    this.color = Colors.lightBlueAccent,
    required this.num,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final int num;
  final Function onTap;

  get boxIndex {
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 100,
        width: 100,
        color: color,
        child: Center(
          child: Text(
            num.toString(),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

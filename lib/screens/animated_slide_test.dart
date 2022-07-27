import 'package:flutter/material.dart';
import 'game_screen.dart';

class SlideTest extends StatefulWidget {
  const SlideTest({Key? key}) : super(key: key);

  @override
  State<SlideTest> createState() => _SlideTestState();
}

class _SlideTestState extends State<SlideTest> {
  Offset offset = Offset(0, 0);
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.grey,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              AnimatedSlide(
                duration: Duration(milliseconds: 200),
                offset: offset,
                child: AnimatedScale(
                  duration: Duration(milliseconds: 100),
                  scale: hover ? .8 : 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        offset += Offset(1, 0);
                      });
                    },
                    child: MouseRegion(
                      onEnter: (a) {
                        setState(() {
                          hover = !hover;
                        });
                      },
                      onExit: (a) {
                        setState(() {
                          hover = !hover;
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.lightBlue,
                        child: Center(
                          child: Text('1'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  offset -= Offset(1, 0);
                });
                print(offset);
              },
              child: Text('LEFT'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  offset += Offset(1, 0);
                });
                print(offset);
              },
              child: Text('RIGHT'),
            ),
          ],
        )
      ],
    );
  }
}

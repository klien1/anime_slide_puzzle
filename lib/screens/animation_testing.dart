import 'dart:math';

import 'package:anime_slide_puzzle/screens/animate_child.dart';
import 'package:flutter/material.dart';

class AnimationTesting extends StatefulWidget {
  const AnimationTesting({Key? key}) : super(key: key);

  @override
  State<AnimationTesting> createState() => _AnimationTestingState();
}

class _AnimationTestingState extends State<AnimationTesting>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityController;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // opacityController = Tween<double>(begin: 0, end: 1).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(begin, end)
    //   ),
    // );

    // controller.forward();
    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  Animation<double> getInterval(int index, double maxValue, int maxIndex) {
    double startPoint = maxValue / maxIndex;
    double interval = startPoint * index;
    // print('interval: $interval');
    // print(startPoint + interval);
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          interval,
          startPoint + interval,
          curve: Curves.fastOutSlowIn,
        ),
        // curve: Curves.linear,
      ),
    );
  }

  Animation<int> getPositionAnimation() {
    return Tween<int>(begin: -300, end: 0).animate(
      CurvedAnimation(
          parent: controller,
          curve: Interval(getRandomRange(.25), getRandomRange(.25) + .25,
              curve: Curves.bounceInOut)),
    );
  }

  double getRandomRange(max) {
    return Random().nextDouble() * max;
  }

  Future<void> _playAnimationForward() async {
    try {
      await controller.forward().orCancel;
      print('animation completed');
    } on TickerCanceled {
      print('ticker canceled');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _playAnimationReverse() async {
    try {
      await controller.reverse().orCancel;
    } on TickerCanceled {
      print('ticker canceled');
    } catch (e) {
      print(e);
    }
  }

  Widget testing() {
    return Stack(children: [
      Container(
        width: 1000,
        height: 500,
        color: Colors.lightBlue,
        child:
            // GridView.count(
            Stack(
          // crossAxisCount: 5,
          children: [
            for (int i = 0; i < 10; ++i)
              AnimatedChild(
                controller: controller,
                opacityAnimation: getInterval(i, 1, 25),
                positionAnimation: getPositionAnimation(),
                index: i,
              )
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // print(controller.value);
    return Column(
      children: [
        testing(),
        TextButton(
            onPressed: () async {
              await _playAnimationForward();
            },
            child: Text('forward')),
        TextButton(
            onPressed: () async {
              await _playAnimationReverse();
            },
            child: Text('reverse'))
      ],
    );
  }
}

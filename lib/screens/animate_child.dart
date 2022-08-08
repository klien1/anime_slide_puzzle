import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedChild extends StatefulWidget {
  AnimatedChild({
    Key? key,
    required this.controller,
    required this.opacityAnimation,
    required this.positionAnimation,
    required this.index,
  }) : super(key: key);

  final AnimationController controller;
  final Animation<double> opacityAnimation;
  final int index;

  final Animation<int> positionAnimation;

  @override
  State<AnimatedChild> createState() => _AnimatedChildState();
}

class _AnimatedChildState extends State<AnimatedChild> {
  final double size = 200;

  late final animatedPosition;

  // final animationPercent = Curves.easeOut.transform(
  double getRandomRange(min, max) {
    double diff = max - min;
    return Random().nextDouble() * diff + min;
  }

  @override
  void initState() {
    super.initState();

    double start = getRandomRange(.40, .60) - (widget.index / 5 * .25);
    double end = getRandomRange(.70, .90) - ((widget.index / 5) * .25);
    // print('index: ${widget.index} start: $start end: $end');
    // print(end);

    animatedPosition =
        Tween<double>(begin: -200, end: 50 + (widget.index ~/ 5) * 210)
            .animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, end, curve: Curves.easeIn),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final animationPercent = Curves.easeOut.transform(
    //   const Interval(0.5, 1).transform(controller.value),
    // );
    // print('contrller value = ${controller.value}');
    // final double slideDistance = (1 - animationPercent) * 100;
    final borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(10))
        .animate(widget.controller);

    // animatedPosition =
    //     Tween<double>(begin: -200, end: 50 + (widget.index ~/ 5) * 210).animate(
    //   CurvedAnimation(
    //     parent: widget.controller,
    //     curve: Interval(getRandomRange(.25) * widget.index / 5,
    //         getRandomRange(.25) * (widget.index / 5) + .50,
    //         curve: Curves.bounceInOut),
    //   ),
    // );
    // print(animatedPosition.value);

    // animatedPosition.addListener()

    return AnimatedBuilder(
        builder: (context, child) => Positioned(
              left: (widget.index % 5) * (5 + size),
              top: animatedPosition.value,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: borderAnimation.value,
                  // border: borderAnimation,
                  color: (widget.index > 4) ? Colors.amber : Colors.red,
                ),
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  // opacity: 1,
                  child: Text('child'),
                ),
              ),
            ),
        animation: widget.controller);
  }
}

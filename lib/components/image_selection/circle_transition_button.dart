import 'package:anime_slide_puzzle/components/image_selection/circle_transition_clipper.dart';
import 'package:flutter/material.dart';

class CircleTransitionButton extends StatelessWidget {
  const CircleTransitionButton({
    Key? key,
    required this.destinationScreen,
    required this.buttonText,
    this.pageTransitionDuration = const Duration(seconds: 2),
    this.transitionStartPosition = const Offset(0, 0),
  }) : super(key: key);

  final Duration pageTransitionDuration;
  final Widget destinationScreen;
  final String buttonText;
  final Offset transitionStartPosition;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: pageTransitionDuration,
            reverseTransitionDuration: pageTransitionDuration,
            pageBuilder: (
              context,
              animation,
              secondaryAniamtion,
            ) =>
                destinationScreen,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              double beginRadius = 0.0;
              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;
              double endRadius = (screenWidth > screenHeight)
                  ? screenWidth * 1.3
                  : screenHeight * 1.3;

              var radiusTween = Tween(begin: beginRadius, end: endRadius);
              var radiusTweenAnimation = animation.drive(radiusTween);

              return ClipPath(
                clipper: CircleTransitionClipper(
                  center: transitionStartPosition,
                  radius: radiusTweenAnimation.value,
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: Text(buttonText),
    );
  }
}

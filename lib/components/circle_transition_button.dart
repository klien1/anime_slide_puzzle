import 'package:flutter/material.dart';

class CircleTransitionButton extends StatelessWidget {
  const CircleTransitionButton({
    Key? key,
    required this.destinationScreen,
    required this.buttonText,
    this.buttonStyle,
    this.textStyle,
    this.pageTransitionDuration = const Duration(seconds: 1),
    this.transitionStartPosition = const Offset(0, 0),
  }) : super(key: key);

  final Duration pageTransitionDuration;
  final Widget destinationScreen;
  final String buttonText;
  final Offset transitionStartPosition;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle,
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: pageTransitionDuration,
            reverseTransitionDuration: pageTransitionDuration,
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
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
                  ? screenWidth * 1.4
                  : screenHeight * 1.4;

              var radiusTween = Tween(begin: beginRadius, end: endRadius);
              var radiusTweenAnimation = animation.drive(radiusTween);

              return ClipPath(
                clipper: _CircleTransitionClipper(
                  center: transitionStartPosition,
                  radius: radiusTweenAnimation.value,
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: Text(
        buttonText,
        style: textStyle,
      ),
    );
  }
}

class _CircleTransitionClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _CircleTransitionClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

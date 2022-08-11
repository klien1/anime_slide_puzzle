import 'package:anime_slide_puzzle/constants.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.web,
  }) : super(key: key);

  final Widget mobile;
  final Widget tablet;
  final Widget web;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < small) {
        return mobile;
      } else if (constraints.maxWidth < medium) {
        return tablet;
      } else {
        return web;
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: Colors.black,
      backgroundColor: Color(0xFFc2c2c2),
      body: SpinKitPouringHourGlassRefined(
        color: Colors.black,
        size: 100,
      ),
    );
  }
}

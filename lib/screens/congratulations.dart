import 'package:flutter/material.dart';

class Congratulations extends StatelessWidget {
  const Congratulations(
      {Key? key, required this.totalTime, required this.numMoves})
      : super(key: key);

  final String totalTime;
  final int numMoves;

  static String id = 'congratulations_screen';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Text(
          'You have completed the puzzle in $totalTime with $numMoves moves!'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }
}

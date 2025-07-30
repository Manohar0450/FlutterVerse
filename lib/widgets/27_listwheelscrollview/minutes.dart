import 'package:flutter/material.dart';

class MyMinutes extends StatelessWidget {
  final int minutes;
  const MyMinutes({super.key, required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        minutes < 10 ? '0$minutes' : minutes.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

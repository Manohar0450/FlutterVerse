import 'package:flutter/material.dart';
import 'first_page.dart';

class SecondPage extends StatelessWidget {
  final int numberSecond;
  const SecondPage({super.key, required this.numberSecond});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FirstPage(numberFirst: numberSecond),
              ),
            );
          },
          child: const Text('First Page'),
        ),
      ),
    );
  }
}

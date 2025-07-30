import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Question 1:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Which of the following is used for state management in Flutter?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showResult(context, false),
              child: const Text("Scaffold"),
            ),
            ElevatedButton(
              onPressed: () => _showResult(context, true),
              child: const Text("Provider"),
            ),
            ElevatedButton(
              onPressed: () => _showResult(context, false),
              child: const Text("MaterialApp"),
            ),
            ElevatedButton(
              onPressed: () => _showResult(context, false),
              child: const Text("ThemeData"),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Wrong"),
        content: Text(
          isCorrect
              ? "Well done! 'Provider' is commonly used for state management in Flutter."
              : "Oops! Try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

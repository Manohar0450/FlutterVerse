import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final int score;
  final int total;
  final String quizType;
  final String topic;

  const ResultsPage({
    super.key,
    required this.score,
    required this.total,
    required this.quizType,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double percentage = (score / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quizType,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              topic,
              style: TextStyle(
                fontSize: 18,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$score/$total (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 20,
              backgroundColor: theme.colorScheme.surface,
              color: _getScoreColor(percentage),
            ),
            const SizedBox(height: 20),
            Text(
              _getResultMessage(percentage),
              style: TextStyle(
                fontSize: 18,
                color: _getScoreColor(percentage),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Return to Home',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 80) return 'Excellent Work!';
    if (percentage >= 60) return 'Good Job!';
    if (percentage >= 40) return 'Keep Practicing!';
    return 'Review the Material';
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}
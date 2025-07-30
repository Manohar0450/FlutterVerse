import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz_result_provider.dart';

class ResultsOverviewPage extends StatelessWidget {
  const ResultsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = Provider.of<QuizResultProvider>(context).allResults;
    final averageScore = Provider.of<QuizResultProvider>(context).getOverallAverage();

    return Scaffold(
      appBar: AppBar(title: const Text('My Quiz Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Overall Performance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Average Score: ${averageScore.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: averageScore / 100,
                      minHeight: 20,
                      backgroundColor: theme.colorScheme.surface,
                      color: _getScoreColor(averageScore),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.topic),
                      subtitle: Text(
                        '${result.score}/${result.total} (${result.percentage.toStringAsFixed(1)}%)',
                      ),
                      trailing: Text(
                        '${result.date.day}/${result.date.month}/${result.date.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      leading: Icon(
                        result.percentage >= 60 ? Icons.check_circle : Icons.error,
                        color: result.percentage >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}
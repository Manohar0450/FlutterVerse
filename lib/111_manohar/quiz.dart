import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'result.dart';
import 'quiz_result_provider.dart';

class QuizPage extends StatefulWidget {
  final String topic;

  const QuizPage({super.key, required this.topic});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the primary use of Container widget?',
      'answers': [
        'For layout and styling',
        'For state management',
        'For navigation',
        'For HTTP requests'
      ],
      'correctIndex': 0,
    },
    {
      'question': 'Which property controls a Container\'s dimensions?',
      'answers': ['width/height', 'color', 'child', 'margin'],
      'correctIndex': 0,
    },
  ];

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentIndex]['correctIndex']) {
      setState(() => _score++);
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      final resultProvider = Provider.of<QuizResultProvider>(context, listen: false);
      resultProvider.addResult(QuizResult(
        topic: widget.topic,
        score: _score,
        total: _questions.length,
        quizType: 'Quiz',
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            score: _score,
            total: _questions.length,
            quizType: 'Quiz',
            topic: widget.topic,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.topic)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: theme.colorScheme.surface,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              _questions[_currentIndex]['question'],
              style: TextStyle(
                fontSize: 20,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              _questions[_currentIndex]['answers'].length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: Text(
                    _questions[_currentIndex]['answers'][index],
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
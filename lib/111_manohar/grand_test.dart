import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'result.dart';
import 'quiz_result_provider.dart';

class GrandTestPage extends StatefulWidget {
  final int testNumber;
  final String difficulty;

  const GrandTestPage({
    super.key,
    required this.testNumber,
    required this.difficulty,
  });

  @override
  _GrandTestPageState createState() => _GrandTestPageState();
}

class _GrandTestPageState extends State<GrandTestPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestionsForTest(widget.testNumber, widget.difficulty);
  }

  List<Map<String, dynamic>> _generateQuestionsForTest(int testNumber, String difficulty) {
    List<Map<String, dynamic>> questions = [];

    // Generate questions based on difficulty level
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        questions = [
          {
            'question': 'Which widget would you use to create a vertical list of items?',
            'answers': ['Row', 'Column', 'Stack', 'Container'],
            'correctIndex': 1,
            'explanation': 'Column widget arranges its children vertically',
          },
          {
            'question': 'What is the primary purpose of the Container widget?',
            'answers': [
              'To add padding and margins',
              'To manage state',
              'To handle HTTP requests',
              'To create animations'
            ],
            'correctIndex': 0,
            'explanation': 'Container is mainly used for layout and styling',
          },
        ];
        break;

      case 'intermediate':
        questions = [
          {
            'question': 'How would you implement a tabbed interface?',
            'answers': [
              'Using TabBar and TabView',
              'With multiple Scaffolds',
              'Using PageView',
              'With NavigationRail'
            ],
            'correctIndex': 0,
            'explanation': 'TabBar with TabView provides standard tabbed interface',
          },
        ];
        break;

      case 'advanced':
        questions = [
          {
            'question': 'What is the purpose of InheritedWidget?',
            'answers': [
              'To efficiently propagate data down the widget tree',
              'To create animations',
              'To handle user gestures',
              'To manage HTTP requests'
            ],
            'correctIndex': 0,
            'explanation': 'InheritedWidget efficiently shares data with descendants',
          },
        ];
        break;
    }

    // Add more questions based on test number if needed
    if (testNumber == 2) {
      questions.addAll([
        {
          'question': 'Sample question for test 2',
          'answers': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
          'correctIndex': 0,
        },
      ]);
    }

    return questions;
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex]['correctIndex']) {
      setState(() => _score++);
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      final resultProvider = Provider.of<QuizResultProvider>(context, listen: false);
      resultProvider.addResult(QuizResult(
        topic: '${widget.difficulty} Grand Test ${widget.testNumber}',
        score: _score,
        total: _questions.length,
        quizType: 'Grand Test',
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            score: _score,
            total: _questions.length,
            quizType: '${widget.difficulty} Grand Test ${widget.testNumber}',
            topic: 'Comprehensive Assessment',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Grand Test ${widget.testNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: theme.colorScheme.surface,
              color: _getButtonColor(widget.difficulty),
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 10),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              _questions[_currentQuestionIndex]['answers'].length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: _getButtonColor(widget.difficulty),
                  ),
                  child: Text(
                    _questions[_currentQuestionIndex]['answers'][index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return Colors.green;
      case 'intermediate': return Colors.orange;
      case 'advanced': return Colors.red;
      default: return Colors.purple;
    }
  }
}
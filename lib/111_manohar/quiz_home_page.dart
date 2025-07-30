import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz.dart';
import 'grand_test.dart';
import 'results_overview_page.dart';
import 'quiz_result_provider.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  // All topics organized by difficulty
  final List<String> allTopics = const [
    // Beginner Topics (1-30)
    'Container', 'Expanded', 'Column', 'Row', 'ListView',
    'SingleChildScrollView', 'ImageAsset', 'GridView', 'GestureDetector',
    'BottomNavBar', 'AppBar', 'Drawer', 'SliverAppBar', 'TabBar',
    'AnimatedContainer', 'MediaQuery', 'AlertDialog', 'TextStyle',
    'RichText', 'Timer', 'PageView', 'Stack', 'TextField',
    'AnimatedIcon', 'Slider', 'DatePicker', 'TimePicker',
    'ListWheelScrollView', 'LinearGradient', 'ElevatedButton',

    // Intermediate Topics (31-60)
    'FloatingActionButton', 'RawMaterialButton', 'IconButton', 'Navigator',
    'Card', 'CustomClipper', 'RotatedBox', 'Transform', 'Positioned',
    'CustomPaint', 'ClipOval', 'ClipRRect', 'ClipRect', 'ClipPath',
    'RadialGradient', 'StatefulWidget', 'Table', 'DataTable',
    'Placeholder', 'GestureInk', 'Material', 'Switches',
    'DropDownPopupMenu', 'HeroAnimation', 'AboutDialog', 'Stepper',
    'FittedBox', 'ShowSearch', 'Adaptive', 'Scrollbar',

    // Advanced Topics (61-90+)
    'ChoiceChip', 'Wrap', 'ExpansionTile', 'RangeSlider',
    'ShowModalBottomSheet', 'AnimatedCrossFade', 'Flexible', 'Spacer',
    'GridPaper', 'InteractiveViewer', 'CheckboxListTile', 'SelectableText',
    'AnimatedPadding', 'RefreshIndicator', 'ImageFiltered', 'AspectRatio',
    'ToggleButton', 'PhysicalModel', 'Align', 'SafeArea',
    'PageRouteBuilder', 'Draggable', 'BackdropFilter', 'ReorderableListView',
    'FadeTransition', 'CircleAvatar', 'Tooltip', 'Visibility',
    'IndexedStack', 'Navigator2', 'InheritedWidget', 'FractionallySizedBox',
    'ConstrainedBox', 'StatefulBuilder', 'LayoutBuilder', 'OrientationBuilder',
    'FutureBuilder', 'StreamBuilder', 'ChangeNotifier', 'ValueNotifier'
  ];

  @override
  Widget build(BuildContext context) {
    final quizResultProvider = Provider.of<QuizResultProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Quiz and Grand Tests'),
        actions: const [
          Icon(Icons.notifications_none_outlined, color: Colors.white),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('JD', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultsOverviewPage(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.assessment),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionHeader(title: 'Topic Quizzes'),
            ..._buildTopicQuizzes(context, quizResultProvider),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Grand Tests by Difficulty'),
            _buildGrandTestCard(
              context,
              title: 'Beginner Grand Test',
              description: 'Covers basic widgets (1-30)',
              testNumber: 1,
              difficulty: 'Beginner',
              topics: allTopics.sublist(0, 30),
            ),
            _buildGrandTestCard(
              context,
              title: 'Intermediate Grand Test',
              description: 'Covers intermediate widgets (31-60)',
              testNumber: 2,
              difficulty: 'Intermediate',
              topics: allTopics.sublist(30, 60),
            ),
            _buildGrandTestCard(
              context,
              title: 'Advanced Grand Test',
              description: 'Covers advanced widgets (61-90)',
              testNumber: 3,
              difficulty: 'Advanced',
              topics: allTopics.sublist(60, 90),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopicQuizzes(
      BuildContext context, QuizResultProvider quizResultProvider) {
    return allTopics
        .map((topic) => _buildQuizCard(
              context,
              title: topic,
              questions: _getQuestionCount(topic),
              highScore: quizResultProvider.getHighScoreForTopic(topic),
              difficulty: _getDifficulty(topic),
              quizResultProvider: quizResultProvider,
            ))
        .toList();
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required String title,
    required int questions,
    required int highScore,
    required String difficulty,
    required QuizResultProvider quizResultProvider,
  }) {
    final theme = Theme.of(context);
    final topicResults = quizResultProvider.getResultsForTopic(title);
    final latestResult = topicResults.isNotEmpty ? topicResults.last : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$questions Questions',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                if (latestResult != null)
                  Text(
                    'Last: ${latestResult.percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _getScoreColor(latestResult.percentage),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (latestResult == null)
                  Text(
                    'Not taken yet',
                    style: TextStyle(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(difficulty).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      color: _getDifficultyColor(difficulty),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _navigateToQuiz(context, title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrandTestCard(
    BuildContext context, {
    required String title,
    required String description,
    required int testNumber,
    required String difficulty,
    required List<String> topics,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(difficulty).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      color: _getDifficultyColor(difficulty),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Covers: ${topics.take(5).join(', ')}${topics.length > 5 ? '...' : ''}',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  _navigateToGrandTest(context, testNumber, difficulty),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Take $difficulty Test',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  int _getQuestionCount(String topic) {
    final index = allTopics.indexOf(topic);
    if (index < 30) return 10; // Beginner
    if (index < 60) return 15; // Intermediate
    return 20; // Advanced
  }

  String _getDifficulty(String topic) {
    final index = allTopics.indexOf(topic);
    if (index < 30) return 'Beginner';
    if (index < 60) return 'Intermediate';
    return 'Advanced';
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  void _navigateToQuiz(BuildContext context, String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(topic: topic),
      ),
    );
  }

  void _navigateToGrandTest(
      BuildContext context, int testNumber, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrandTestPage(
          testNumber: testNumber,
          difficulty: difficulty,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'quiz_screen.dart';

class LearningModuleScreen extends StatefulWidget {
  const LearningModuleScreen({super.key});

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerVisible = false;
  bool _isVideoEnded = false;

  final String _videoId = 'm2hWRdTBLQ8';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
        hideControls: true,
        controlsVisibleAtStart: false,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.playerState == PlayerState.ended && !_isVideoEnded) {
      setState(() {
        _isVideoEnded = true;
      });
    }
  }

  void _showCodeSample() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''// Sample Code
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '\$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/$_videoId/0.jpg';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text("State Management in Flutter")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            !_isPlayerVisible
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(thumbnailUrl),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            size: 64, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _isPlayerVisible = true;
                          });
                          _controller.play();
                        },
                      ),
                    ],
                  )
                : YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  ),
            const SizedBox(height: 16),
            const Text(
              'Flutter state management is crucial for building scalable and maintainable applications. It dictates how data is shared and updated across different widgets.\n\nKey concepts include:\n\n• Provider — A simple yet powerful state management solution.\n• ChangeNotifier — Sends notifications to its listeners.\n• Consumer — Rebuilds UI when the model updates.\n• Selector — Helps optimize UI rebuilds.\n\nUnderstanding these helps you build efficient apps.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showCodeSample,
              icon: const Icon(Icons.code),
              label: const Text("View Sample Code & Output"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _isVideoEnded
                  ? ElevatedButton(
                      onPressed: _startQuiz,
                      child: const Text("Start Quiz"),
                    )
                  : const Text(
                      "🔒 Watch the full video to unlock the quiz.",
                      style: TextStyle(color: Colors.redAccent),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

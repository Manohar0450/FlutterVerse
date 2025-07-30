import 'package:flutter/material.dart';

class QuizResult {
  final String topic;
  final int score;
  final int total;
  final DateTime date;
  final String quizType;

  QuizResult({
    required this.topic,
    required this.score,
    required this.total,
    required this.quizType,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  double get percentage => (score / total) * 100;
}

class QuizResultProvider with ChangeNotifier {
  final List<QuizResult> _results = [];

  List<QuizResult> get allResults => List.from(_results);

  void addResult(QuizResult result) {
    _results.add(result);
    notifyListeners();
  }

  List<QuizResult> getResultsForTopic(String topic) {
    return _results.where((r) => r.topic == topic).toList();
  }

  double getOverallAverage() {
    if (_results.isEmpty) return 0;
    final total = _results.fold(0.0, (sum, r) => sum + r.percentage);
    return total / _results.length;
  }

  int getHighScoreForTopic(String topic) {
    final topicResults = getResultsForTopic(topic);
    if (topicResults.isEmpty) return 0;
    return topicResults
        .reduce((a, b) => a.percentage > b.percentage ? a : b)
        .percentage
        .round();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz_home_page.dart';
import 'quiz_result_provider.dart';

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizResultProvider()),
      ],
      child: const MaterialApp(
        title: 'Quiz and Grand Tests',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        home: QuizHomePage(),
      ),
    );
  }
}

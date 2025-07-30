import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:community/111_shahid/login_screen.dart';

import '../111_shahid/login_screen.dart';
import '../flutterverse_navbar.dart';
import '../utils/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool _move = false;

  @override
  void initState() {
    super.initState();

    // Bubble movement toggle
    _timer = Timer.periodic(const Duration(seconds:1), (timer) {
      setState(() {
        _move = !_move;
      });
    });

    // Navigate to the next screen after a delay
    Future.delayed(const Duration(seconds: 4), () async {
      _timer.cancel(); // Stop the timer to prevent further updates
      final token = await TokenStorage.getToken();
      // If token exists, navigate to the main app screen
      if (token != null && token.isNotEmpty) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FlutterVerseNavBar()),
        );
        // Check if the widget is still mounted before showing snackbar
      }
      // If no token, navigate to the login screen
      else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black87, Color(0xFF1E3A54)],
              ),
            ),
          ),

          // ⬆⬇ Animated Circles with more movement
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: _move ? 60 : 140,
            left: _move ? 80 : 130,
            child: Circle(
              size: 180,
              color: Colors.deepPurple.withOpacity(0.3),
              borderColor: Colors.purpleAccent.withOpacity(0.4),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: _move ? 200 : 300,
            left: _move ? 30 : 80,
            child: Circle(
              size: 220,
              color: Colors.blue.withOpacity(0.1),
              borderColor: Colors.cyanAccent.withOpacity(0.3),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            bottom: _move ? 120 : 200,
            right: _move ? 30 : 100,
            child: Circle(
              size: 160,
              color: Colors.blue.withOpacity(0.15),
              borderColor: Colors.cyan.withOpacity(0.4),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            bottom: _move ? 40 : 100,
            left: _move ? 30 : 100,
            child: Circle(
              size: 120,
              color: Colors.blueGrey.withOpacity(0.2),
              borderColor: Colors.blueAccent.withOpacity(0.4),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: _move ? 40 : 120,
            right: _move ? 40 : 110,
            child: Circle(
              size: 80,
              color: Colors.purple.withOpacity(0.3),
              borderColor: Colors.blueAccent,
            ),
          ),

          // FlutterVerse Logo Text
          const Center(
            child: Text(
              'FlutterVerse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Circle widget (same)
class Circle extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;

  const Circle({
    super.key,
    required this.size,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
    );
  }
}
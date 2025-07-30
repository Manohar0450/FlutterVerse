// import 'package:community/110_chatbot_screen/chatbot_screen.dart';
import 'package:flutter/material.dart';
import './111_manohar/1_quiz_screen.dart';
import './111_srinivas/home_screen.dart';
import './111_mehar/community_screen.dart';
import './110_chatbot_screen/chatbot_screen.dart';
import './111_srinivas/profile_screen.dart';

class FlutterVerseNavBar extends StatefulWidget {
  const FlutterVerseNavBar({super.key});

  @override
  State<FlutterVerseNavBar> createState() => _FlutterVerseNavBarState();
}

class _FlutterVerseNavBarState extends State<FlutterVerseNavBar> {
  int _selectIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final List<Widget> screens = [
    const SrinivasHomeScreen(),
    const QuizApp(),
    const ChatScreen(),
    const CommunityForumPage(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectIndex == 0 ? true : false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectIndex != 0) {
          setState(() {
            _selectIndex=0; 
          });
        }
      },
      child: Scaffold(
        body: screens[_selectIndex],
        bottomNavigationBar: Container(
          color: Colors.black,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white12,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.quiz_outlined), label: 'Quiz'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.child_care_outlined), label: 'FlutterBot'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline_outlined), label: 'Community'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            currentIndex: _selectIndex,
            onTap: _navigateBottomBar,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}

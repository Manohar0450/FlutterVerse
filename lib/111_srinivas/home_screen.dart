import 'package:flutter/material.dart';

import '../111_shankar/course_screen.dart';

class SrinivasHomeScreen extends StatefulWidget {
  const SrinivasHomeScreen({super.key});

  @override
  State<SrinivasHomeScreen> createState() => _SrinivasHomeScreenState();
}

class _SrinivasHomeScreenState extends State<SrinivasHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Home',
          textScaler: TextScaler.linear(1),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Daily Learning Streak",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ],
                            ),
                            const Text(
                              "7 Days",
                              textScaler: TextScaler.linear(1),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              textScaler: TextScaler.linear(1),
                              "You're on fire! Keep up the great work and\ncomplete today's module.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const CourseScreen(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                    textScaler: TextScaler.linear(1),
                                    "Start Today’s Module"),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Today's Tip",
                          textScaler: TextScaler.linear(1),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb_outline_rounded,
                                    size: 25, color: Colors.blue),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text('Mastering Flutter Layouts',
                                      textScaler: TextScaler.linear(1),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              textScaler: TextScaler.linear(1),
                              'Explore the power of Row, Column, and Stack widgets for responsive UI. Experiment with flex properties and constrained boxes to build beautiful interfaces.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        const BorderSide(color: Colors.white12),
                                  ),
                                ),
                                child: const Text('Learn More',
                                    textScaler: TextScaler.linear(1),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Leaderboard",
                          textScaler: TextScaler.linear(1),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          _buildLeaderboardRow(
                            rank: 1,
                            name: "Alice Johnson",
                            xp: 1250,
                            icon: Icons.emoji_events_outlined,
                            iconColor: Colors.white,
                            isYou: false,
                          ),
                          _buildLeaderboardRow(
                            rank: 2,
                            name: "Bob Smith",
                            xp: 1180,
                            icon: Icons.emoji_events_outlined,
                            iconColor: Colors.white,
                            isYou: false,
                          ),
                          _buildLeaderboardRow(
                            rank: 3,
                            name: "Charlie Brown",
                            xp: 1020,
                            icon: Icons.emoji_events_outlined,
                            iconColor: Colors.white,
                            isYou: false,
                          ),
                          _buildLeaderboardRow(
                            rank: 15,
                            name: "You (You)",
                            xp: 675,
                            icon: Icons.emoji_events_outlined,
                            iconColor: Colors.white,
                            isYou: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardRow({
    required int rank,
    required String name,
    required int xp,
    required IconData icon,
    required Color iconColor,
    required bool isYou,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isYou ? Colors.blue : Colors.grey, width: isYou ? 2 : 0.5),
      ),
      child: Row(
        children: [
          Text(
            "$rank",
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text(
              textScaler: const TextScaler.linear(1),
              name.trim().substring(0, 2).toUpperCase(), // First 2 letters
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textScaler: const TextScaler.linear(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isYou ? Colors.white : Colors.white,
                  ),
                ),
                Text(
                  "$xp XP",
                  textScaler: const TextScaler.linear(1),
                  style: TextStyle(
                    color: isYou ? Colors.white70 : Colors.grey,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}

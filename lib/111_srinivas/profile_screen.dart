import 'package:FlutterVerse/services/auth_service.dart';

import '../111_srinivas/daily_streak_screen.dart';
import 'package:flutter/material.dart';

import 'EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreakScreen(),
              ),
            );
          },
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.local_fire_department_outlined,size: 30,),
          ),
          color: Colors.white,
        ),
        // backgroundColor: const Color(0xFF0F0F10),
        elevation: 0,
        centerTitle: true,
        title: Text('Profile',textScaler: TextScaler.linear(1),style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenWidth * 0.05),
              CircleAvatar(
                radius: screenWidth * 0.1,
                backgroundColor: Colors.blue,
                child: Text(
                  'AJ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Alex Johnson',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Passionate Flutter developer learning new skills every day. Building beautiful and functional apps.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Learning Progress
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bar_chart, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Learning Progress',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      ),
                      SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: 0.72,
                        backgroundColor: Colors.white24,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 8),
                      Text('Completed 72 out of 100 modules',
                          style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Badge Carousel
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Badges',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const FlutterBadgeCarousel(),
              const SizedBox(height: 20),

              // Certificates
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Certificates',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              buildCertificateCard('Course Completion Certificate', 'Issued: October 2023'),
              const SizedBox(height: 10),

              // Logout
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AuthService.logout(context);
                      },
                      child: Text("Logout",
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.logout_outlined, size: 25, color: Colors.red),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget buildCertificateCard(String title, String issued) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child:ListTile(title: Text(title, style: const TextStyle(color: Colors.white,fontSize: 14)),
          subtitle: Text(issued,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Certificate',textScaler: TextScaler.linear(1), style: TextStyle(fontSize: 10,color: Colors.white)),
          ),),

    );
  }
}

// 🔁 Responsive Badge Carousel
class FlutterBadgeCarousel extends StatefulWidget {
  const FlutterBadgeCarousel({super.key});

  @override
  State<FlutterBadgeCarousel> createState() => _FlutterBadgeCarouselState();
}

class _FlutterBadgeCarouselState extends State<FlutterBadgeCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.6);

  final List<String> badgeImagePaths = [
    'assets/flutter_bronze.jpg',
    'assets/flutter_silver.jpg',
    'assets/flutter_gold.png',
  ];

  final List<String> badgeTitles = [
    'Flutter Bronze',
    'Flutter Silver',
    'Flutter Gold',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenWidth * 0.55,
      child: PageView.builder(
        controller: _controller,
        itemCount: badgeImagePaths.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = 1.0;
              if (_controller.position.haveDimensions) {
                value = (_controller.page ?? _controller.initialPage.toDouble()) - index;
                value = (1 - (value.abs() * 0.4)).clamp(0.7, 1.0);
              }

              return Center(
                child: Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.5,
                          height: screenWidth * 0.45,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              badgeImagePaths[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          badgeTitles[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

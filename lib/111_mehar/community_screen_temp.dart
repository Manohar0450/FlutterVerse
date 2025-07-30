import 'package:flutter/material.dart';
import 'dart:math' show Random;

class CommunityForumPage1 extends StatefulWidget {
  const CommunityForumPage1({super.key});

  @override
  _CommunityForumPageState createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage1> {
  String _selectedTab = 'questions';
  final String currentUserId = 'AV';

  // Mock data for posts
  final List<Map<String, dynamic>> posts = [
    {
      'type': 'poll',
      'userId': 'Jane Smith',
      'content': const PollCard(),
      'time': '2 hours ago',
    },
    {
      'type': 'question',
      'userId': 'Markus K.',
      'content': const TextPostCard(),
      'time': '4 hours ago',
    },
    {
      'type': 'question',
      'userId': 'AV',
      'content': const ImagePostCard(),
      'time': '1 day ago',
    },
    {
      'type': 'question',
      'userId': 'AV',
      'content': const TextPostCard(),
      'time': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Community Forum",
            textScaler: TextScaler.linear(1),
          ),
          actions: const [
            Icon(Icons.notifications_none_outlined, color: Colors.white),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('JD',textScaler: TextScaler.linear(1), style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _tabButton("Questions", _selectedTab == 'questions'),
                  const SizedBox(width: 30),
                  _tabButton("Polls", _selectedTab == 'polls'),
                  const SizedBox(width: 30),
                  _tabButton("For You", _selectedTab == 'for_you'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: _filteredPosts(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreatePostDialog(context),
          backgroundColor: Colors.pink,
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _tabButton(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label.toLowerCase().replaceAll(' ', '_');
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? Colors.pink.shade700 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _filteredPosts() {
    List<Widget> filtered = [];
    for (var post in posts) {
      if (_selectedTab == 'questions' && post['type'] == 'question') {
        filtered.add(post['content']);
        filtered.add(const SizedBox(height: 10));
      } else if (_selectedTab == 'polls' && post['type'] == 'poll') {
        filtered.add(post['content']);
        filtered.add(const SizedBox(height: 10));
      } else if (_selectedTab == 'for_you' &&
          post['type'] == 'question' &&
          post['userId'] == currentUserId) {
        filtered.add(post['content']);
        filtered.add(const SizedBox(height: 10));
      }
    }
    return filtered.isNotEmpty
        ? filtered
        : [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "No posts available",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          ];
  }

  void _showCreatePostDialog(BuildContext context) {
    bool isPoll = false;
    final TextEditingController titleController = TextEditingController();
    final List<TextEditingController> optionControllers = [
      TextEditingController(),
      TextEditingController(),
    ];
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Create Post',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? null
                        : Colors.white),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ChoiceChip(
                            label: const Text('Question'),
                            selected: !isPoll,
                            onSelected: (selected) {
                              setDialogState(() => isPoll = !selected);
                            },
                            selectedColor: Colors.pink.shade700,
                            labelStyle: TextStyle(
                                color: !isPoll ? Colors.white : Colors.grey),
                          ),
                          ChoiceChip(
                            label: const Text('Poll'),
                            selected: isPoll,
                            onSelected: (selected) {
                              setDialogState(() => isPoll = selected);
                            },
                            selectedColor: Colors.pink.shade700,
                            labelStyle: TextStyle(
                                color: isPoll ? Colors.white : Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: isPoll ? 'Poll Question' : 'Question',
                          labelStyle: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? null
                                  : Colors.white60),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? null
                                    : Colors.white),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a question' : null,
                      ),
                      if (isPoll) ...[
                        const SizedBox(height: 16),
                        ...List.generate(
                          optionControllers.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              controller: optionControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Option ${index + 1}',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? null
                                        : Colors.white60),
                                filled: true,
                                fillColor: Colors.grey.shade800,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? null
                                      : Colors.white),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter option ${index + 1}'
                                  : null,
                            ),
                          ),
                        ),
                        if (optionControllers.length < 4)
                          TextButton(
                            onPressed: () {
                              setDialogState(() {
                                optionControllers.add(TextEditingController());
                              });
                            },
                            child: const Text(
                              'Add Option',
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? null
                            : Colors.white60),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _addPost(
                        isPoll: isPoll,
                        title: titleController.text,
                        options: isPoll
                            ? optionControllers
                                .map((controller) => controller.text)
                                .toList()
                            : [],
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade700),
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      for (var controller in optionControllers) {
        controller.dispose();
      }
    });
  }

  void _addPost({
    required bool isPoll,
    required String title,
    required List<String> options,
  }) {
    setState(() {
      Widget content;
      if (isPoll) {
        content = CustomPollCard(
          question: title,
          options: options,
          userId: currentUserId,
          time: 'Just now',
        );
      } else {
        content = CustomTextPostCard(
          question: title,
          userId: currentUserId,
          time: 'Just now',
        );
      }
      posts.insert(0, {
        'type': isPoll ? 'poll' : 'question',
        'userId': currentUserId,
        'content': content,
        'time': 'Just now',
      });
    });
  }
}

// ------------------ CustomPollCard ------------------

class CustomPollCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String userId;
  final String time;

  const CustomPollCard({
    super.key,
    required this.question,
    required this.options,
    required this.userId,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final votePercentages = List.generate(options.length,
        (_) => random.nextDouble() * 0.8 / options.length + 0.1);
    final sum = votePercentages.reduce((a, b) => a + b);
    final normalized = votePercentages.map((v) => v / sum).toList();

    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userHeader(userId, time),
            const SizedBox(height: 12),
            Text(
              question,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white,
                  fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return _pollOption(option, normalized[index]);
            }).toList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _pollOption(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            height: 40,
            width: 280 * value,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "$label ${(value * 100).toInt()}%",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ CustomTextPostCard ------------------

class CustomTextPostCard extends StatelessWidget {
  final String question;
  final String userId;
  final String time;

  const CustomTextPostCard({
    super.key,
    required this.question,
    required this.userId,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UserHeader(name: userId, time: time),
            const SizedBox(height: 12),
            Text(
              question,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white),
            ),
            const SizedBox(height: 12),
            const _PostFooter(likes: 0, views: 0, comments: 0),
          ],
        ),
      ),
    );
  }
}

// ------------------ PollCard ------------------

class PollCard extends StatelessWidget {
  const PollCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userHeader("Jane Smith", "2 hours ago"),
            const SizedBox(height: 12),
            Text(
              "How do you solve complex Flutter state management?",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white,
                  fontSize: 16),
            ),
            const SizedBox(height: 16),
            _pollOption("Provider", 0.55),
            _pollOption("Riverpod", 0.35),
            _pollOption("Bloc/Cubit", 0.25),
            _pollOption("GetX", 0.15),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _pollOption(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            height: 40,
            width: 280 * value,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "$label ${(value * 100).toInt()}%",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ TextPostCard ------------------

class TextPostCard extends StatelessWidget {
  const TextPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _UserHeader(name: "Markus K.", time: "4 hours ago"),
            const SizedBox(height: 12),
            Text(
              "Just finished my first complex animation in Flutter! "
              "The AnimatedBuilder widget is a lifesaver. "
              "Any tips for optimizing performance on #FlutterAnimation?\n#PerformanceTips",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white),
            ),
            const SizedBox(height: 12),
            const _PostFooter(likes: 88, views: 210, comments: 35),
          ],
        ),
      ),
    );
  }
}

// ------------------ ImagePostCard ------------------

class ImagePostCard extends StatelessWidget {
  const ImagePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _UserHeader(name: "Alice L.", time: "1 day ago"),
            const SizedBox(height: 12),
            const Placeholder(fallbackHeight: 120),
            const SizedBox(height: 12),
            Text(
              "My new setup for Flutter development! Loving the multi-monitor workflow. "
              "What does your Flutter workspace look like? #DevSetup #Flutter",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white),
            ),
            const SizedBox(height: 12),
            const _PostFooter(likes: 150, views: 450, comments: 80),
          ],
        ),
      ),
    );
  }
}

// ------------------ Reusable Components ------------------

class _UserHeader extends StatelessWidget {
  final String name;
  final String time;

  const _UserHeader({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            name[0],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white),
            ),
            Text(
              time,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white60,
                  fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _userHeader(String name, String time) =>
    _UserHeader(name: name, time: time);

class _PostFooter extends StatelessWidget {
  final int likes;
  final int views;
  final int comments;

  const _PostFooter({
    required this.likes,
    required this.views,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _footerItem(Icons.thumb_up, likes),
        const SizedBox(width: 20),
        _footerItem(Icons.remove_red_eye, views),
        const SizedBox(width: 20),
        _footerItem(Icons.chat_bubble_outline, comments),
      ],
    );
  }

  Widget _footerItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 4),
        Text("$count", style: const TextStyle(color: Colors.white38)),
      ],
    );
  }
}

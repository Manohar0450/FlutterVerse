import 'package:FlutterVerse/111_mehar/community_screen_temp.dart';
import 'package:flutter/material.dart';
import 'package:FlutterVerse/constants/api_constants.dart';
import 'package:FlutterVerse/models/post_model.dart';
import 'package:FlutterVerse/services/post_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  String selectedTab = 'question';
  List<PostModel> posts = [];
  bool isLoading = true;
  final PostService _postService = PostService();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    initSocket();
  }

  void initSocket() {
    try{
      print('Connecting to socket at $apiSocketUrl');
    socket = IO.io(apiSocketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onConnectError((err) {
      print('❌ Socket connection error: $err');
    });

    socket.onError((data) {
      print('❗ General socket error: $data');
    });

    socket.on('new_post', (data) {
      final newPost = PostModel.fromJson(data);
      setState(() {
        posts.insert(0, newPost);
      });
    });

    socket.on('like_updated', (data) {
      final postId = data['postId'];
      final likes = data['likes'];
      setState(() {
        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) posts[index] = posts[index].copyWith(likes: likes);
      });
    });

    socket.on('new_comment', (data) {
      final postId = data['postId'];
      setState(() {
        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          // You can optionally show comment count increase or refresh comments
          print('New comment added to post: $postId');
        }
      });
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
    } catch (e) {
      print('Socket connection error: $e');
    }
  }

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);
    posts = await _postService.fetchPosts(type: selectedTab);
    setState(() => isLoading = false);
  }

  void changeTab(String tab) {
    selectedTab = tab;
    fetchPosts();
  }

  Widget buildTab(String label, String value) {
    final isSelected = selectedTab == value;
    return GestureDetector(
      onTap: () => changeTab(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pinkAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1E28),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E28),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Community Forum',
          textScaler: TextScaler.linear(1),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityForumPage1()),
                );
              },
              child: Icon(Icons.notifications_none)),
          SizedBox(width: 12),
          CircleAvatar(
              child: Text(
            'JD',
            textScaler: TextScaler.linear(1),
          )),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTab("Questions", "question"),
                buildTab("Polls", "poll"),
                buildTab("For You", "foryou"),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : posts.isEmpty
                    ? const Center(
                        child: Text("No posts found",
                            style: TextStyle(color: Colors.white70)),
                      )
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Card(
                            color: const Color(0xFF2C2F3E),
                            margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.content,
                                      style: const TextStyle(
                                          color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.thumb_up,
                                              color: Colors.white70, size: 18),
                                          const SizedBox(width: 4),
                                          Text(post.likes.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white70)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.visibility,
                                              color: Colors.white70, size: 18),
                                          const SizedBox(width: 4),
                                          Text(post.views.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white70)),
                                        ],
                                      ),
                                      const Icon(Icons.comment,
                                          color: Colors.white70, size: 18),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreatePostDialog(context),
          backgroundColor: Colors.pink,
          child: const Icon(Icons.edit),
        ),
    );
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
    }
}


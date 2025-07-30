//post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/post_model.dart';

class PostService {
  Future<List<PostModel>> fetchPosts({String type = 'question'}) async {
    final url = Uri.parse('${apiBaseUrl}/posts?type=$type');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      print('📡 Requesting: $url');
      print('🔁 Response Code: ${res.statusCode}');
      print('🧾 Body: ${res.body}');
      return data.map((e) => PostModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load posts");
  }

  Future<bool> createPost(String content, String type, List<String> tags, String token) async {
    final url = Uri.parse('${apiBaseUrl}/posts');
    final res = await http.post(url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'type': type,
        'tags': tags,
      }),
    );

    return res.statusCode == 200;
  }

  Future<void> likePost(String postId) async {
    final url = Uri.parse('${apiBaseUrl}/posts/$postId/like');
    await http.patch(url);
  }

  Future<void> viewPost(String postId) async {
    final url = Uri.parse('${apiBaseUrl}/posts/$postId/view');
    await http.patch(url);
  }
}

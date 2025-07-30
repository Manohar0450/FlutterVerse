import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';
import '../constants/api_constants.dart';

class CommentService {
  Future<List<CommentModel>> getComments(String postId) async {
    final url = Uri.parse('${apiBaseUrl}/comments/$postId');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => CommentModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load comments");
  }

  Future<bool> addComment(String postId, String content, String token) async {
    final url = Uri.parse('${apiBaseUrl}/comments/$postId');
    final res = await http.post(url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': content}),
    );

    return res.statusCode == 200;
  }
}

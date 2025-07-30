//post_model.dart
class PostModel {
  final String id;
  final String content;
  final String type;
  final List<String> tags;
  final int likes;
  final int views;
  final String userId;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.content,
    required this.type,
    required this.tags,
    required this.likes,
    required this.views,
    required this.userId,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      content: json['content'],
      type: json['type'],
      tags: List<String>.from(json['tags']),
      likes: json['likes'],
      views: json['views'],
      userId: json['user'] is String ? json['user'] : json['user']['_id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  PostModel copyWith({
    String? id,
    String? content,
    String? type,
    List<String>? tags,
    int? likes,
    int? views,
    String? userId,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

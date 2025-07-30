class CommentModel {
  final String id;
  final String content;
  final String userId;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      content: json['content'],
      userId: json['user'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

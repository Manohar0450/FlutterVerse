class UserProgressModel {
  final String courseId;
  final int levelNumber;
  final List<String> completedTopics;

  UserProgressModel({
    required this.courseId,
    required this.levelNumber,
    required this.completedTopics,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      courseId: json['courseId'],
      levelNumber: json['levelNumber'],
      completedTopics: List<String>.from(json['completedTopics'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'levelNumber': levelNumber,
      'completedTopics': completedTopics,
    };
  }
}

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? token;
  final String? profilePicture;
  final String? bio;
  final bool isVerified;
  final int streakCount;
  final DateTime? createdAt;
  final DateTime? lastQuizDate;
  final List<UserProgressModel> progress;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.profilePicture,
    this.bio,
    this.isVerified = false,
    this.streakCount = 0,
    this.createdAt,
    this.lastQuizDate,
    this.progress = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
      profilePicture: json['profilePicture'] ?? '',
      bio: json['bio'] ?? '',
      isVerified: json['isVerified'] ?? false,
      streakCount: json['streakCount'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastQuizDate: json['lastQuizDate'] != null
          ? DateTime.parse(json['lastQuizDate'])
          : null,
      progress: (json['progress'] as List<dynamic>?)
              ?.map((e) => UserProgressModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'token': token,
      'profilePicture': profilePicture,
      'bio': bio,
      'isVerified': isVerified,
      'streakCount': streakCount,
      'createdAt': createdAt?.toIso8601String(),
      'lastQuizDate': lastQuizDate?.toIso8601String(),
      'progress': progress.map((e) => e.toJson()).toList(),
    };
  }
}

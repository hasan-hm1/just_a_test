import 'dart:convert';

class Comment {
  final String comment;
  final String userEmail;

  Comment({required this.comment, required this.userEmail});

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'userEmail': userEmail,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      comment: map['comment'] ?? '',
      userEmail: map['userEmail'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));
}

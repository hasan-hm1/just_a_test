import 'dart:convert';

import 'package:interview_test/data/models/announcements/comment.dart';

class Announcement {
  final String title;
  final String body;
  final String? documentId;
  final List<Comment> comments;

  Announcement(
      {required this.title,
      required this.body,
      this.comments = const [],
        this.documentId});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'documentId': documentId,
      'comments': comments.map((x) => x.toMap()).toList(),
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      title: map['title'],
      body: map['body'],
      documentId: map['documentId'],
      comments: map['comments'] == null
          ? []
          : List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Announcement.fromJson(String source) =>
      Announcement.fromMap(json.decode(source));
}

import 'package:flutter/material.dart';
import 'package:interview_test/data/models/announcements/comment.dart';

class CommentListItem extends StatelessWidget {
  final Comment comment;

  const CommentListItem({Key? key, required this.comment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              comment.userEmail,
              style: TextStyle(
                color: Colors.pink.withOpacity(0.3),
              ),
            ),
            Text(comment.comment),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview_test/data/models/announcements/comment.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/res/app_res.dart';

class CommentsRepository {
  final String announcementId;
  final _firestrore = FirebaseFirestore.instance;

  CommentsRepository({required this.announcementId});

  Future<void> addComment(Comment comment) async {
    try {
      await _firestrore
          .collection(AppContants.announcementsColllectionName)
          .doc(this.announcementId)
          .collection(AppContants.commentsColllectionName)
          .add(comment.toMap());
    } on Error catch (_) {
      throw AppError();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview_test/data/models/announcements/announcement.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/res/app_res.dart';

class AnouncementsRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addAnnouncement(Announcement announcement) async {
    try {
      await _firestore
          .collection(AppContants.announcementsColllectionName)
          .add(announcement.toMap());
    } on Error catch (_) {
      throw AppError();
    }
  }
}

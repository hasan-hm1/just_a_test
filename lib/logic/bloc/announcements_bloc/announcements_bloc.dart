import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_test/data/models/announcements/announcement.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/data/repositories/announcements_repository.dart';
import 'package:interview_test/res/app_res.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  late final StreamSubscription subscription;
  final _firestore = FirebaseFirestore.instance;
  final AnouncementsRepository announcementsRepository;
  AnnouncementsBloc(this.announcementsRepository)
      : super(AnnouncementsInitial()) {
    _listenToAnnouncements();
  }

  void _listenToAnnouncements() {
    subscription = _firestore
        .collection(AppContants.announcementsColllectionName)
        .snapshots()
        .listen((snapshot) async {
      try {
        final List<Announcement> announcements = [];

        await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
          snapshot.docs,
          (doc) async {
            final Map<String, dynamic> announcentMap = {};

            announcentMap.addAll(doc.data());
            announcentMap.addAll({
              'documentId': doc.reference.id,
            });

            final data = await doc.reference
                .collection(AppContants.commentsColllectionName)
                .get();
          final  List<Map<String, dynamic>> comments = [];

            data.docs.forEach((commet) {
              comments.add(commet.data());
            });
            announcentMap.addAll({'comments': comments});

            announcements.add(
              Announcement.fromMap(announcentMap),
            );
          },
        );

        emit(
          AnnouncementsFetched(
            announcements: announcements,
          ),
        );
      } catch (e) {
        emit(AnnouncementsError());
      }
    });
  }

  @override
  Stream<AnnouncementsState> mapEventToState(
    AnnouncementsEvent event,
  ) async* {
    yield AnnouncementsLoading();

    try {
      if (event is AddAnnouncement) {
        //TODO: error handling
        await announcementsRepository.addAnnouncement(event.announcement);
      }
    } on AppError catch (_) {
      yield AnnouncementsError();
    }
  }

  void dispose() {
    subscription.cancel();
  }
}

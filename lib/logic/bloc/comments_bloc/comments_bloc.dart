import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_test/data/models/announcements/comment.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/data/repositories/comments_repository.dart';
import 'package:interview_test/res/app_res.dart';
 

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  late final StreamSubscription subscription;
  final CommentsRepository commentsRepository;
  final _firestrore = FirebaseFirestore.instance;
  CommentsBloc(this.commentsRepository) : super(CommentsInitial()) {
    _listenToComments();
  }

  void _listenToComments() {
    subscription = _firestrore
        .collection(AppContants.announcementsColllectionName)
        .doc(this.commentsRepository.announcementId)
        .collection(AppContants.commentsColllectionName)
        .snapshots()
        .listen((snapshot) {
      final List<Comment> comments = [];
      snapshot.docs.forEach((comment) {
        comments.add(Comment.fromMap(comment.data()));
      });

      emit(CommentsFetched(comments: comments));
    });

    subscription.onError((e) {
      emit(CommentsError());
    });
  }

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    yield CommentsLoading();

    try {
      if (event is AddComment) {
        //TODO: error handling
        await commentsRepository.addComment(event.comment);
      }
    } on AppError catch (e) {
      yield CommentsError(errorMessage: e.errorMessage!);
    }
  }

  void dispose() {
    subscription.cancel();
  }
}

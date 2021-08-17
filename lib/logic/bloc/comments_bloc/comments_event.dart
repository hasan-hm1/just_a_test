part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class AddComment extends CommentsEvent {
  final Comment comment;

  AddComment({required this.comment});


  @override
  List<Object> get props => [comment];
}

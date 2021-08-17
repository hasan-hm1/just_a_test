part of 'comments_bloc.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}
class CommentsError extends CommentsState {
  final String errorMessage ;

  CommentsError({  this.errorMessage = AppContants.errorDefaultMessage});
}

class CommentsFetched extends CommentsState {
final  List<Comment> comments   ;

  CommentsFetched({required this.comments});


  List<Object> get props => [comments];

}

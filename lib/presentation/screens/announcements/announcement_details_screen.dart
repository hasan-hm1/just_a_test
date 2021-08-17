import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/data/models/announcements/announcement.dart';
import 'package:interview_test/data/repositories/auth_repository.dart';
import 'package:interview_test/enums/user_type.dart';
import 'package:interview_test/logic/bloc/comments_bloc/comments_bloc.dart';
import 'package:interview_test/presentation/widgets/add_comment_modal.dart';
import 'package:interview_test/presentation/widgets/announcement_list_item.dart';
import 'package:interview_test/presentation/widgets/comment_list_item.dart';
import 'package:interview_test/presentation/widgets/common.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailsScreen({Key? key, required this.announcement})
      : super(key: key);
  @override
  _AnnouncementDetailsScreenState createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  @override
  void dispose() {
    // close snapshots stream subscription
    context.read<CommentsBloc>().dispose();
    super.dispose();
  }

  void _addComment() {
    final bloc = context.read<CommentsBloc>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: AddCommentModal(),
      ),
    );
  }

  Widget _buildCommentsLayout() {
    return Expanded(
      child: BlocBuilder<CommentsBloc, CommentsState>(builder: (ctx, state) {
        if (state is CommentsError) {
          return Center(
            child: Text('Error'),
          );
        } else if (state is CommentsFetched) {
          if (state.comments.isEmpty) {
            return Center(child: Text('No comments for now'),);
          }
          return ListView.builder(
            itemBuilder: (ctx, index) =>
                CommentListItem(comment: state.comments[index]),
            itemCount: state.comments.length,
          );
        }

        return CeneteredCircualrProgressIndicator();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Announcement Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              AnnouncementListItem(announcement: widget.announcement),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Comments :',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink.withOpacity(0.3),
                    ),
                  ),
                  Spacer(),
                  if (context.read<AuthRepository>().userType ==
                      UserType.student)
                    IconButton(
                      onPressed: _addComment,
                      icon: Icon(
                        Icons.add,
                        color: Colors.pink.withOpacity(0.3),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _buildCommentsLayout(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/data/models/announcements/announcement.dart';
import 'package:interview_test/data/repositories/comments_repository.dart';
import 'package:interview_test/logic/bloc/comments_bloc/comments_bloc.dart';
import 'package:interview_test/presentation/screens/announcements/announcement_details_screen.dart';

class AnnouncementListItem extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementListItem({Key? key, required this.announcement})
      : super(key: key);

  Widget _buildAnnouncementBodyLayout() {
    return Padding(
        padding: const EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 20,
        ),
        child: Text(
          announcement.body,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Widget _buildAnnoncementTitleLayout() {
    return Expanded(
      child: Text(
        announcement.title,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _navigateToDetailsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CommentsBloc(
            CommentsRepository(announcementId: announcement.documentId!),
          ),
          child: AnnouncementDetailsScreen(announcement: announcement),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          _navigateToDetailsScreen(context);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    _buildAnnoncementTitleLayout(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              _buildAnnouncementBodyLayout(),
            ],
          ),
        ),
      ),
    );
  }
}

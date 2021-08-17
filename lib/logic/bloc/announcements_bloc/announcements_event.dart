part of 'announcements_bloc.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object> get props => [];
}

class AddAnnouncement extends AnnouncementsEvent {
  final Announcement announcement;

  AddAnnouncement({required this.announcement});

  @override
  List<Object> get props => [announcement];
}

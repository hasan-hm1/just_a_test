part of 'announcements_bloc.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();
  
  @override
  List<Object> get props => [];
}

class AnnouncementsInitial extends AnnouncementsState {}
class AnnouncementsError extends AnnouncementsState {}

class AnnouncementsFetched extends AnnouncementsState {
  final List<Announcement> announcements;

  AnnouncementsFetched({required this.announcements});

  @override
  List<Object> get props => [announcements];
}

class AnnouncementsLoading extends AnnouncementsState{}

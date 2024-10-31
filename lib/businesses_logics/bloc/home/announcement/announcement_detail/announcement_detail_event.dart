part of 'announcement_detail_bloc.dart';

abstract class AnnouncementDetailEvent extends Equatable {
  const AnnouncementDetailEvent();

  @override
  List<Object> get props => [];
}

class AnnouncementDetailViewLoaded extends AnnouncementDetailEvent {
  final int annId;
  final GeneralBloc generalBloc;

  const AnnouncementDetailViewLoaded({
    required this.annId,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [annId, generalBloc];
}

class AnnouncementDetailUpdate extends AnnouncementDetailEvent {
  final String cmt;
  final int annId;
  final GeneralBloc generalBloc;

  const AnnouncementDetailUpdate(
      {required this.cmt, required this.annId, required this.generalBloc});
  @override
  List<Object> get props => [cmt, annId, generalBloc];
}

part of 'inbound_photo_bloc.dart';

abstract class InboundPhotoEvent extends Equatable {
  const InboundPhotoEvent();

  @override
  List<Object?> get props => [];
}

class InboundPhotoViewLoaded extends InboundPhotoEvent {
  final DateTime date;
  final GeneralBloc generalBloc;
  const InboundPhotoViewLoaded(
      {required this.date,
      
      required this.generalBloc});
  @override
  List<Object?> get props => [date, generalBloc];
}

class InboundPhotoPreviousDateLoaded extends InboundPhotoEvent {
  final GeneralBloc generalBloc;
  const InboundPhotoPreviousDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class InboundPhotoNextDateLoaded extends InboundPhotoEvent {
  final GeneralBloc generalBloc;
  const InboundPhotoNextDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class InboundPhotoPickDate extends InboundPhotoEvent {
  final DateTime date;
  final GeneralBloc generalBloc;
  const InboundPhotoPickDate({
    required this.date,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [date, generalBloc];
}

class InboundPhotoPaging extends InboundPhotoEvent {
  final GeneralBloc generalBloc;

  const InboundPhotoPaging({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

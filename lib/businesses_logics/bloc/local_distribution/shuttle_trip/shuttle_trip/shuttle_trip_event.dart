part of 'shuttle_trip_bloc.dart';

abstract class ShuttleTripEvent extends Equatable {
  const ShuttleTripEvent();

  @override
  List<Object?> get props => [];
}

class ShuttleTripViewLoaded extends ShuttleTripEvent {
  // final String? pageId;
  // final String? pageName;
  final GeneralBloc generalBloc;
  const ShuttleTripViewLoaded(
      {/* this.pageId, this.pageName, */ required this.generalBloc});

  @override
  List<Object?> get props => [/* pageId, pageName, */ generalBloc];
}

class ShuttleTripChangeMonth extends ShuttleTripEvent {
  final GeneralBloc generalBloc;
  final DateTime dateTime;
  const ShuttleTripChangeMonth(
      {required this.dateTime, required this.generalBloc});
  @override
  List<Object> get props => [dateTime, generalBloc];
}

class ShuttleTripChangeDate extends ShuttleTripEvent {
  final DateTime dateTime;
  const ShuttleTripChangeDate({
    required this.dateTime,
  });
  @override
  List<Object> get props => [dateTime];
}

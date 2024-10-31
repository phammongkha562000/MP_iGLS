part of 'track_and_trace_bloc.dart';

sealed class TrackAndTraceEvent extends Equatable {
  const TrackAndTraceEvent();

  @override
  List<Object> get props => [];
}

class TrackAndTraceLoaded extends TrackAndTraceEvent {
  final CustomerBloc customerBloc;
  const TrackAndTraceLoaded({required this.customerBloc});
  @override
  List<Object> get props => [];
}

class GetUnlocPodEvent extends TrackAndTraceEvent {
  final String unlocCode;
  const GetUnlocPodEvent({required this.unlocCode});
  @override
  List<Object> get props => [];
}

class GetUnlocPolEvent extends TrackAndTraceEvent {
  final String unlocCode;
  const GetUnlocPolEvent({required this.unlocCode});
  @override
  List<Object> get props => [];
}

class GetTrackAndTraceEvent extends TrackAndTraceEvent {
  final GetTrackAndTraceReq model;
  final String strCompany;
  const GetTrackAndTraceEvent({required this.model, required this.strCompany});
  @override
  List<Object> get props => [];
}

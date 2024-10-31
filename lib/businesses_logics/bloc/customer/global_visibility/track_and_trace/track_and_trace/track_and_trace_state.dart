part of 'track_and_trace_bloc.dart';

sealed class TrackAndTraceState extends Equatable {
  const TrackAndTraceState();

  @override
  List<Object> get props => [];
}

final class TrackAndTraceInitial extends TrackAndTraceState {}

final class TrackAndTraceLoadedSuccess extends TrackAndTraceState {
  final List<TrackAndTraceStatusRes> lstStatus;
  const TrackAndTraceLoadedSuccess({required this.lstStatus});
  @override
  List<Object> get props => [];
}

final class TrackAndTraceLoadedFail extends TrackAndTraceState {
  final String message;
  const TrackAndTraceLoadedFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetUnlocPodSuccessState extends TrackAndTraceState {
  final List<GetUnlocResult> lstUnloc;
  const GetUnlocPodSuccessState({required this.lstUnloc});
  @override
  List<Object> get props => [];
}

final class GetUnlocFailState extends TrackAndTraceState {
  final String message;
  const GetUnlocFailState({required this.message});
  @override
  List<Object> get props => [];
}

final class GetUnlocPolSuccessState extends TrackAndTraceState {
  final List<GetUnlocResult> lstUnloc;
  const GetUnlocPolSuccessState({required this.lstUnloc});
  @override
  List<Object> get props => [];
}

final class GetTrackAndTraceFailState extends TrackAndTraceState {
  final String message;
  const GetTrackAndTraceFailState({required this.message});
  @override
  List<Object> get props => [];
}

final class GetTrackAndTraceSuccessState extends TrackAndTraceState {
  final List<TrackAndTraceStatusRes> lstTrackTrace;
  const GetTrackAndTraceSuccessState({required this.lstTrackTrace});
  @override
  List<Object> get props => [];
}

final class ShowLoadingState extends TrackAndTraceState {}

final class HideLoadingState extends TrackAndTraceState {}

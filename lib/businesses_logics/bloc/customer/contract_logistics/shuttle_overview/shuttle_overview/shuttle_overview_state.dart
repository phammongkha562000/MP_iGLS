part of 'shuttle_overview_bloc.dart';

sealed class ShuttleOverviewState extends Equatable {
  const ShuttleOverviewState();

  @override
  List<Object?> get props => [];
}

final class ShuttleOverviewInitial extends ShuttleOverviewState {}

final class ShuttleOverviewLoading extends ShuttleOverviewState {}

final class ShuttleOverviewSuccess extends ShuttleOverviewState {
  final CustomerShuttleOverviewRes shuttleOverview;

  const ShuttleOverviewSuccess({required this.shuttleOverview});
  @override
  List<Object?> get props => [shuttleOverview];
}

final class ShuttleOverviewFailure extends ShuttleOverviewState {
  final int? errorCode;
  final String message;

  const ShuttleOverviewFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

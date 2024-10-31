part of 'transport_overview_bloc.dart';

sealed class TransportOverviewState extends Equatable {
  const TransportOverviewState();

  @override
  List<Object?> get props => [];
}

final class TransportOverviewInitial extends TransportOverviewState {}

final class TransportOverviewLoading extends TransportOverviewState {}

final class TransportOverviewSuccess extends TransportOverviewState {
  final CustomerTransportOverviewRes transportOverview;

  const TransportOverviewSuccess({required this.transportOverview});
  @override
  List<Object?> get props => [transportOverview];
}

final class TransportOverviewFailure extends TransportOverviewState {
  final int? errorCode;
  final String message;

  const TransportOverviewFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

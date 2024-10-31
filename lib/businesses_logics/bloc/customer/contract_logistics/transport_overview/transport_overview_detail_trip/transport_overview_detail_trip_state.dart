part of 'transport_overview_detail_trip_bloc.dart';

sealed class TransportOverviewDetailTripState extends Equatable {
  const TransportOverviewDetailTripState();

  @override
  List<Object?> get props => [];
}

final class TransportOverviewDetailTripInitial
    extends TransportOverviewDetailTripState {}

final class TransportOverviewDetailTripLoading
    extends TransportOverviewDetailTripState {}

final class TransportOverviewDetailTripSuccess
    extends TransportOverviewDetailTripState {
  final ToDoTripDetailResponse detail;

  const TransportOverviewDetailTripSuccess({required this.detail});
  @override
  List<Object?> get props => [detail];
}

final class TransportOverviewDetailTripFailure
    extends TransportOverviewDetailTripState {
  final int? errorCode;
  final String message;

  const TransportOverviewDetailTripFailure(
      {this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

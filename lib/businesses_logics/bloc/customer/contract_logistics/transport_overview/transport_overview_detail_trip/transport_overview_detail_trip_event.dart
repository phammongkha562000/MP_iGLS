part of 'transport_overview_detail_trip_bloc.dart';

sealed class TransportOverviewDetailTripEvent extends Equatable {
  const TransportOverviewDetailTripEvent();

  @override
  List<Object> get props => [];
}

class TransportOverviewDetailTripViewLoaded
    extends TransportOverviewDetailTripEvent {
  final String tripNo;
  final String subsidiaryId;

  const TransportOverviewDetailTripViewLoaded(
      {required this.tripNo, required this.subsidiaryId});
  @override
  List<Object> get props => [tripNo, subsidiaryId];
}

part of 'transport_overview_bloc.dart';

sealed class TransportOverviewEvent extends Equatable {
  const TransportOverviewEvent();

  @override
  List<Object> get props => [];
}

class TransportOverviewViewLoaded extends TransportOverviewEvent {
  final CustomerTransportOverviewReq content;

  const TransportOverviewViewLoaded({required this.content});
  @override
  List<Object> get props => [content];
}

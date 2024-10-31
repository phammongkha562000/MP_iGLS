part of 'outbound_order_status_search_bloc.dart';

sealed class OutboundOrderStatusSearchEvent extends Equatable {
  const OutboundOrderStatusSearchEvent();

  @override
  List<Object> get props => [];
}

class OutboundOrderStatusSearchViewLoaded
    extends OutboundOrderStatusSearchEvent {
  final CustomerBloc customerBloc;

  const OutboundOrderStatusSearchViewLoaded({required this.customerBloc});
  @override
  List<Object> get props => [customerBloc];
}

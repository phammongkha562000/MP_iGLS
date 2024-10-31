part of 'inbound_order_status_search_bloc.dart';

sealed class InboundOrderStatusSearchEvent extends Equatable {
  const InboundOrderStatusSearchEvent();

  @override
  List<Object> get props => [];
}

class InboundOrderStatusSearchViewLoaded extends InboundOrderStatusSearchEvent {
  final CustomerBloc customerBloc;

  const InboundOrderStatusSearchViewLoaded({required this.customerBloc});
  @override
  List<Object> get props => [customerBloc];
}

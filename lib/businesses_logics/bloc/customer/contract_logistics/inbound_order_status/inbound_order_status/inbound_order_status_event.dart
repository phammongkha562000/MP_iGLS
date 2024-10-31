part of 'inbound_order_status_bloc.dart';

sealed class CustomerIOSEvent extends Equatable {
  const CustomerIOSEvent();

  @override
  List<Object> get props => [];
}

class CustomerIOSViewLoaded extends CustomerIOSEvent {
  final CustomerBloc customerBloc;
  const CustomerIOSViewLoaded({
    required this.customerBloc,
  });
  @override
  List<Object> get props => [customerBloc];
}

class CustomerGetInboundOrder extends CustomerIOSEvent {
  final String subsidiaryId;
  final GetInboundOrderReq model;

  const CustomerGetInboundOrder(
      {required this.subsidiaryId, required this.model});
  @override
  List<Object> get props => [subsidiaryId, model];
}

part of 'outbound_order_status_detail_bloc.dart';

sealed class CustomerOOSDetailEvent extends Equatable {
  const CustomerOOSDetailEvent();

  @override
  List<Object> get props => [];
}

class CustomerOOSDetailViewLoaded extends CustomerOOSDetailEvent {
  final int orderId;
  final CustomerBloc customerBloc;
  const CustomerOOSDetailViewLoaded(
      {required this.orderId, required this.customerBloc});
  @override
  List<Object> get props => [orderId, customerBloc];
}

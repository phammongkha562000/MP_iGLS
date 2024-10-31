part of 'transport_order_status_detail_bloc.dart';

sealed class CustomerTOSDetailEvent extends Equatable {
  const CustomerTOSDetailEvent();

  @override
  List<Object> get props => [];
}

class CustomerTOSDetailViewLoaded extends CustomerTOSDetailEvent {
  final CustomerBloc customerBloc;
  final String orderId;
  final String tripNo;
  final String deliveryMode;
  const CustomerTOSDetailViewLoaded({
    required this.orderId,
    required this.tripNo,
    required this.deliveryMode,
    required this.customerBloc,
  });
  @override
  List<Object> get props => [orderId, tripNo, deliveryMode, customerBloc];
}

class CustomerTOSDetailSaveNotify extends CustomerTOSDetailEvent {
  final CustomerBloc customerBloc;

  final String messageType;
  final String notes;
  final String orderId;
  final String receiver;
  final String tripNo;

  const CustomerTOSDetailSaveNotify({
    required this.customerBloc,
    required this.messageType,
    required this.notes,
    required this.orderId,
    required this.receiver,
    required this.tripNo,
  });
  @override
  List<Object> get props =>
      [messageType, notes, orderId, receiver, tripNo, customerBloc];
}

class CustomerTOSDetailDeleteNotify extends CustomerTOSDetailEvent {
  final String tripNo;
  final String orderId;
  final CustomerBloc customerBloc;

  const CustomerTOSDetailDeleteNotify({
    required this.tripNo,
    required this.orderId,
    required this.customerBloc,
  });
  @override
  List<Object> get props => [tripNo, orderId, customerBloc];
}

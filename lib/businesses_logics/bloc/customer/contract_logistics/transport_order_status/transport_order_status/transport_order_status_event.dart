part of 'transport_order_status_bloc.dart';

sealed class CustomerTOSEvent extends Equatable {
  const CustomerTOSEvent();

  @override
  List<Object> get props => [];
}

class CustomerTOSViewLoaded extends CustomerTOSEvent {
  final CustomerBloc customerBloc;
  final CustomerTOSReq content;
  const CustomerTOSViewLoaded({
    required this.customerBloc,
    required this.content,
  });
  @override
  List<Object> get props => [customerBloc, content];
}

class CustomerTOSSearch extends CustomerTOSEvent {
  final CustomerBloc customerBloc;
  final String contactCode;
  final String dcCode;
  final String dateF;
  final String dateT;
  final String orderNo;
  final String orderStatus;
  final String pickUpCode;
  final String shipToCode;
  final String tripNo;

  const CustomerTOSSearch(
      {required this.customerBloc,
      required this.dcCode,
      required this.dateF,
      required this.dateT,
      required this.orderNo,
      required this.orderStatus,
      required this.pickUpCode,
      required this.shipToCode,
      required this.contactCode,
      required this.tripNo});
  @override
  List<Object> get props => [
        dcCode,
        dateF,
        dateT,
        orderNo,
        orderStatus,
        pickUpCode,
        shipToCode,
        tripNo,
        customerBloc,
        contactCode
      ];
}

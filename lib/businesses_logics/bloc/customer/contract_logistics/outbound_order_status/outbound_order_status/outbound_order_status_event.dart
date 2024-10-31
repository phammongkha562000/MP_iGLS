part of 'outbound_order_status_bloc.dart';

class CustomerOOSEvent extends Equatable {
  const CustomerOOSEvent();

  @override
  List<Object> get props => [];
}

class CustomerOOSSearch extends CustomerOOSEvent {
  final CustomerOOSReq model;
  final String subsidiaryId;

  const CustomerOOSSearch({required this.model, required this.subsidiaryId});
  @override
  List<Object> get props => [model, subsidiaryId];  
}

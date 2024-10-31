part of 'inventory_wp_bloc.dart';

sealed class CustomerInventoryWPEvent extends Equatable {
  const CustomerInventoryWPEvent();

  @override
  List<Object> get props => [];
}

class CustomerInventoryWPViewLoaded extends CustomerInventoryWPEvent {
  final CustomerBloc customerBloc;
  const CustomerInventoryWPViewLoaded({
    required this.customerBloc,
  });
  @override
  List<Object> get props => [customerBloc];
}

class CustomerInventoryWPSearch extends CustomerInventoryWPEvent {
  final CustomerInventoryReq model;
  final CustomerBloc customerBloc;

  const CustomerInventoryWPSearch({
    required this.model,
    required this.customerBloc,
  });
  @override
  List<Object> get props => [model, customerBloc];
}

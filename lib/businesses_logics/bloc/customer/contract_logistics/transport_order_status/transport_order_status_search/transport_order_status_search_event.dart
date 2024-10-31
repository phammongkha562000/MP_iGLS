part of 'transport_order_status_search_bloc.dart';

sealed class CustomerTOSSearchEvent extends Equatable {
  const CustomerTOSSearchEvent();

  @override
  List<Object> get props => [];
}

class CustomerTOSSearchViewLoaded extends CustomerTOSSearchEvent {
  final CustomerBloc customerBloc;

  const CustomerTOSSearchViewLoaded({required this.customerBloc});
  @override
  List<Object> get props => [customerBloc];
}

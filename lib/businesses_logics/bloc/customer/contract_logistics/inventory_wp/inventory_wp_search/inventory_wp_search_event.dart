part of 'inventory_wp_search_bloc.dart';

sealed class InventoryWpSearchEvent extends Equatable {
  const InventoryWpSearchEvent();

  @override
  List<Object> get props => [];
}

class InventoryWpSearchViewLoaded extends InventoryWpSearchEvent {
  final CustomerBloc customerBloc;
  const InventoryWpSearchViewLoaded({
    required this.customerBloc,
  });
  @override
  List<Object> get props => [customerBloc];
}

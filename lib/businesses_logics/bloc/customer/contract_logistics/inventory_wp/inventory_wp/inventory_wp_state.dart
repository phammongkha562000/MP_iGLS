part of 'inventory_wp_bloc.dart';

sealed class CustomerInventoryWPState extends Equatable {
  const CustomerInventoryWPState();

  @override
  List<Object?> get props => [];
}

final class CustomerInventoryWPInitial extends CustomerInventoryWPState {}

final class CustomerInventoryWPLoading extends CustomerInventoryWPState {}

final class CustomerInventoryWPSuccess extends CustomerInventoryWPState {
  final List<CustomerInventoryRes> lstInventory;
  final List<CustomerInventoryTotalRes> lstInventoryTotal;

  const CustomerInventoryWPSuccess(
      {required this.lstInventory, required this.lstInventoryTotal});

  CustomerInventoryWPSuccess copyWith({
    List<CustomerInventoryRes>? lstInventory,
    List<CustomerInventoryTotalRes>? lstInventoryTotal,
  }) {
    return CustomerInventoryWPSuccess(
      lstInventory: lstInventory ?? this.lstInventory,
      lstInventoryTotal: lstInventoryTotal ?? this.lstInventoryTotal,
    );
  }

  @override
  List<Object?> get props => [
        lstInventory,
        lstInventoryTotal,
      ];
}

final class CustomerInventoryWPFailure extends CustomerInventoryWPState {
  final String message;
  final int? errorCode;

  const CustomerInventoryWPFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

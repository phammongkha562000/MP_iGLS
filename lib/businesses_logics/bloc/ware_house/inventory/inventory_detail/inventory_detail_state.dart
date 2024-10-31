part of 'inventory_detail_bloc.dart';

abstract class InventoryDetailState extends Equatable {
  const InventoryDetailState();

  @override
  List<Object?> get props => [];
}

class InventoryDetailInitial extends InventoryDetailState {}

class InventoryDetailLoading extends InventoryDetailState {}

class InventoryDetailSuccess extends InventoryDetailState {
  final InventoryDetailResponse inventory;
  final List<ReservedDetailResponse> listReserved;
  const InventoryDetailSuccess({
    required this.inventory,
    required this.listReserved,
  });
  @override
  List<Object> get props => [inventory, listReserved];
}

class InventoryDetailFailure extends InventoryDetailState {
  final String message;
  final int? errorCode;
  const InventoryDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

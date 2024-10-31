part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventorySearchSuccess extends InventoryState {
  final List<ReturnModel>? listInventory;

  final double? totalQty;
  final double? totalReserved;

  const InventorySearchSuccess({
    required this.listInventory,
    this.totalQty,
    this.totalReserved,
  });
  @override
  List<Object?> get props => [inventory, totalQty, totalReserved];
}

class InventorySuccess extends InventoryState {
  final List<LocationStockCountResponse> listLoc;
  final List<ItemCodeResponse> listItemCode;
  final List<String>? listItem;
  final String itemStatus;
  const InventorySuccess({
    required this.listLoc,
    required this.listItemCode,
    this.listItem,
    required this.itemStatus,
  });

  @override
  List<Object?> get props => [
        listLoc,
        listItemCode,
        listItem,
        itemStatus,
      ];

  InventorySuccess copyWith({
    List<LocationStockCountResponse>? listLoc,
    List<ItemCodeResponse>? listItemCode,
    List<String>? listItem,
    String? itemStatus,
    double? totalQty,
    double? totalReserved,
  }) {
    return InventorySuccess(
      listLoc: listLoc ?? this.listLoc,
      listItemCode: listItemCode ?? this.listItemCode,
      listItem: listItem ?? this.listItem,
      itemStatus: itemStatus ?? this.itemStatus,
    );
  }
}

class InventoryFailure extends InventoryState {
  final String message;
  final int? errorCode;
  const InventoryFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class GrNoSearchSuccess extends InventoryState {
  final PalletRelocationResponse pallet;

  const GrNoSearchSuccess({required this.pallet});
  @override
  List<Object?> get props => [pallet];
}

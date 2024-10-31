part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class InventoryLoaded extends InventoryEvent {
  final GeneralBloc generalBloc;
  // final String? pageId;
  // final String? pageName;
  const InventoryLoaded({required this.generalBloc
      // this.pageId,
      // this.pageName,
      });

  @override
  List<Object?> get props => [/* pageId, pageName */ generalBloc];
}

class InventorySearch extends InventoryEvent {
  final String? itemCode;
  final String? locCode;
  final String? itemStatus;
  final GeneralBloc generalBloc;

  const InventorySearch(
      {this.itemCode,
      this.locCode,
      this.itemStatus,
      required this.generalBloc});
  @override
  List<Object?> get props => [itemCode, locCode, itemStatus, generalBloc];
}

class GrNoSearch extends InventoryEvent {
  final String grNo;
  final GeneralBloc generalBloc;

  const GrNoSearch({required this.grNo, required this.generalBloc});
  @override
  List<Object?> get props => [grNo, generalBloc];
}

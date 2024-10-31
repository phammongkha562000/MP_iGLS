part of 'inventory_detail_bloc.dart';

abstract class InventoryDetailEvent extends Equatable {
  const InventoryDetailEvent();

  @override
  List<Object> get props => [];
}

class InventoryDetailLoaded extends InventoryDetailEvent {
  final int sbNo;
  final String dcCode;
  final String contactCode;
  final GeneralBloc generalBloc;

  const InventoryDetailLoaded({
    required this.sbNo,
    required this.dcCode,
    required this.contactCode,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [sbNo, dcCode, contactCode, generalBloc];
}

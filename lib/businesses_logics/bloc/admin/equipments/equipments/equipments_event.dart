part of 'equipments_bloc.dart';

abstract class EquipmentsEvent extends Equatable {
  const EquipmentsEvent();

  @override
  List<Object?> get props => [];
}

class EquipmentsViewLoaded extends EquipmentsEvent {
  final String? pageId;
  final String? pageName;
  final GeneralBloc generalBloc;
  const EquipmentsViewLoaded(
      {this.pageId, this.pageName, required this.generalBloc});
  @override
  List<Object?> get props => [pageId, pageName, generalBloc];
}

class EquipmentsSearch extends EquipmentsEvent {
  final GeneralBloc generalBloc;
  final DcLocal dcSearch;
  final StdCode ownershipSearch;
  final StdCode equipmentGroupSearch;
  final EquipmentTypeResponse equipmentTypeSearch;
  final String assetCode;
  final String equipmentCode;
  final String equipmentDesc;
  final String serialNumber;
  const EquipmentsSearch({
    required this.generalBloc,
    required this.dcSearch,
    required this.ownershipSearch,
    required this.equipmentGroupSearch,
    required this.equipmentTypeSearch,
    required this.assetCode,
    required this.equipmentCode,
    required this.equipmentDesc,
    required this.serialNumber,
  });
  @override
  List<Object> get props => [
        generalBloc,
        dcSearch,
        ownershipSearch,
        equipmentGroupSearch,
        equipmentTypeSearch,
        assetCode,
        equipmentCode,
        equipmentDesc,
        serialNumber
      ];
}

class EquipmentsQuickSearch extends EquipmentsEvent {
  final String textSearch;
  const EquipmentsQuickSearch({required this.textSearch});
  @override
  List<Object?> get props => [textSearch];
}

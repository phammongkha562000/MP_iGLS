part of 'equipments_bloc.dart';

abstract class EquipmentsState extends Equatable {
  const EquipmentsState();

  @override
  List<Object?> get props => [];
}

class EquipmentsInitial extends EquipmentsState {}

class EquipmentsLoading extends EquipmentsState {}

class EquipmentsSuccess extends EquipmentsState {
  final List<DcLocal> dcList;
  final List<EquipmentsResponse> equipmentsList;
  final List<EquipmentsResponse> equipmentsListSearch;
  final List<StdCode> ownershipList;
  final List<StdCode> equipmentGroup;
  final List<EquipmentTypeResponse> equipmentTypeList;
  final DcLocal dcSearch;
  final StdCode ownershipSearch;
  final StdCode equipmentGroupSearch;
  final EquipmentTypeResponse equipmentTypeSearch;
  final String assetCode;
  final String equipmentCode;
  final String equipmentDesc;
  final String serialNumber;

  const EquipmentsSuccess({
    required this.dcList,
    required this.equipmentsList,
    required this.equipmentsListSearch,
    required this.ownershipList,
    required this.equipmentGroup,
    required this.equipmentTypeList,
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
  List<Object?> get props => [
        dcList,
        equipmentsList,
        equipmentsListSearch,
        equipmentGroup,
        ownershipList,
        equipmentTypeList,
        equipmentTypeSearch,
        assetCode,
        equipmentCode,
        equipmentDesc,
        serialNumber
      ];

  EquipmentsSuccess copyWith(
      {List<DcLocal>? dcList,
      List<EquipmentsResponse>? equipmentsList,
      List<EquipmentsResponse>? equipmentsListSearch,
      List<StdCode>? ownershipList,
      List<StdCode>? equipmentGroup,
      List<EquipmentTypeResponse>? equipmentTypeList,
      DcLocal? dcSearch,
      StdCode? ownershipSearch,
      StdCode? equipmentGroupSearch,
      EquipmentTypeResponse? equipmentTypeSearch,
      String? assetCode,
      String? equipmentCode,
      String? equipmentDesc,
      String? serialNumber}) {
    return EquipmentsSuccess(
        dcList: dcList ?? this.dcList,
        equipmentsList: equipmentsList ?? this.equipmentsList,
        equipmentsListSearch: equipmentsListSearch ?? this.equipmentsListSearch,
        ownershipList: ownershipList ?? this.ownershipList,
        equipmentGroup: equipmentGroup ?? this.equipmentGroup,
        equipmentTypeList: equipmentTypeList ?? this.equipmentTypeList,
        dcSearch: dcSearch ?? this.dcSearch,
        ownershipSearch: ownershipSearch ?? this.ownershipSearch,
        equipmentGroupSearch: equipmentGroupSearch ?? this.equipmentGroupSearch,
        equipmentTypeSearch: equipmentTypeSearch ?? this.equipmentTypeSearch,
        assetCode: assetCode ?? this.assetCode,
        equipmentCode: equipmentCode ?? this.equipmentCode,
        equipmentDesc: equipmentDesc ?? this.equipmentDesc,
        serialNumber: serialNumber ?? this.serialNumber);
  }
}

class EquipmentsFailure extends EquipmentsState {
  final String message;
  final int? errorCode;
  const EquipmentsFailure({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

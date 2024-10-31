part of 'equipment_detail_bloc.dart';

abstract class EquipmentDetailEvent extends Equatable {
  const EquipmentDetailEvent();

  @override
  List<Object> get props => [];
}

class EquipmentDetailViewLoaded extends EquipmentDetailEvent {
  final String equipmentCode;
  final int isDeleted;
  final GeneralBloc generalBloc;
  const EquipmentDetailViewLoaded(
      {required this.equipmentCode,
      required this.isDeleted,
      required this.generalBloc});
  @override
  List<Object> get props => [equipmentCode, isDeleted, generalBloc];
}

class EquipmentDetailSelectedRelateDC extends EquipmentDetailEvent {
  final String dcCode;
  const EquipmentDetailSelectedRelateDC({
    required this.dcCode,
  });
  @override
  List<Object> get props => [dcCode];
}

class EquipmentDetailUpdate extends EquipmentDetailEvent {
  final String staffId;
  final String remark;
  final GeneralBloc generalBloc;
  const EquipmentDetailUpdate(
      {required this.staffId, required this.remark, required this.generalBloc});
  @override
  List<Object> get props => [staffId, remark, generalBloc];
}

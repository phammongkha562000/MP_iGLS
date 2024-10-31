part of 'staff_detail_bloc.dart';

abstract class StaffDetailEvent extends Equatable {
  const StaffDetailEvent();

  @override
  List<Object> get props => [];
}

class StaffDetailViewLoaded extends StaffDetailEvent {
  final String userId;
  final GeneralBloc generalBloc;
  const StaffDetailViewLoaded(
      {required this.userId, required this.generalBloc});
  @override
  List<Object> get props => [user, generalBloc];
}

class StaffDetailUpdate extends StaffDetailEvent {
  final StaffUpdateRequest request;
  final GeneralBloc generalBloc;

  const StaffDetailUpdate({required this.request, required this.generalBloc});

  @override
  List<Object> get props => [request, generalBloc];
}

class StaffDetailSelectedRelateDC extends StaffDetailEvent {
  final String dcCode;
  final String staffName;
  final String phone;
  final StdCode roleType;
  final StdCode workingStatus;
  final EquipmentResponse equipment;
  final String remark;
  const StaffDetailSelectedRelateDC({
    required this.dcCode,
    required this.staffName,
    required this.phone,
    required this.roleType,
    required this.workingStatus,
    required this.equipment,
    required this.remark,
  });
  @override
  List<Object> get props =>
      [dcCode, staffName, phone, roleType, workingStatus, equipment, remark];
}

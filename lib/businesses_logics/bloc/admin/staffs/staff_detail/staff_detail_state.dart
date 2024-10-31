part of 'staff_detail_bloc.dart';

abstract class StaffDetailState extends Equatable {
  const StaffDetailState();

  @override
  List<Object?> get props => [];
}

class StaffDetailInitial extends StaffDetailState {}

class StaffDetailLoading extends StaffDetailState {}

class StaffDetailSuccess extends StaffDetailState {
  final StaffDetailResponse staffDetail;
  final List<StdCode> statusWorkingList;
  final List<StdCode> roleTypeList;
  final List<DcLocal> dcList;
  final List<VendorResponse> venderList;
  final List<EquipmentResponse> equipmentList;
  final String userId;
  final String statusWorking;
  final String roleType;
  final String staffName;
  final String mobileNo;
  final String equipment;
  final String remark;
  const StaffDetailSuccess(
      {required this.staffDetail,
      required this.statusWorkingList,
      required this.roleTypeList,
      required this.dcList,
      required this.venderList,
      required this.equipmentList,
      required this.userId,
      required this.statusWorking,
      required this.roleType,
      required this.staffName,
      required this.mobileNo,
      required this.equipment,
      required this.remark});
  @override
  List<Object> get props => [
        staffDetail,
        statusWorkingList,
        dcList,
        roleTypeList,
        venderList,
        equipmentList,
        userId,
        statusWorking,
        roleType,
        staffName,
        mobileNo,
        equipment,
        remark
      ];

  StaffDetailSuccess copyWith(
      {StaffDetailResponse? staffDetail,
      List<StdCode>? statusWorkingList,
      List<StdCode>? roleTypeList,
      List<DcLocal>? dcList,
      List<VendorResponse>? venderList,
      List<EquipmentResponse>? equipmentList,
      String? userId,
      String? statusWorking,
      String? roleType,
      String? staffName,
      String? mobileNo,
      String? equipment,
      String? remark}) {
    return StaffDetailSuccess(
        staffDetail: staffDetail ?? this.staffDetail,
        statusWorkingList: statusWorkingList ?? this.statusWorkingList,
        roleTypeList: roleTypeList ?? this.roleTypeList,
        dcList: dcList ?? this.dcList,
        venderList: venderList ?? this.venderList,
        equipmentList: equipmentList ?? this.equipmentList,
        userId: userId ?? this.userId,
        statusWorking: statusWorking ?? this.statusWorking,
        roleType: roleType ?? this.roleType,
        staffName: staffName ?? this.staffName,
        mobileNo: mobileNo ?? this.mobileNo,
        equipment: equipment ?? this.equipment,
        remark: remark ?? this.remark);
  }
}

class StaffDetailFailure extends StaffDetailState {
  final String message;
  final int? errorCode;
  const StaffDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class StaffDetailUpdateSuccessfully extends StaffDetailState {}

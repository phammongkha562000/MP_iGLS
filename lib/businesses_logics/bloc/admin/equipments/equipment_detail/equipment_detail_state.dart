part of 'equipment_detail_bloc.dart';

abstract class EquipmentDetailState extends Equatable {
  const EquipmentDetailState();

  @override
  List<Object?> get props => [];
}

class EquipmentDetailInitial extends EquipmentDetailState {}

class EquipmentDetailLoading extends EquipmentDetailState {}

class EquipmentDetailSuccess extends EquipmentDetailState {
  final EquipmentDetailResponse detail;
  final List<StaffsResponse> staffList;
  final List<DcLocal> dcList;

  const EquipmentDetailSuccess({
    required this.detail,
    required this.staffList,
    required this.dcList,
  });
  @override
  List<Object?> get props => [detail, staffList, dcList];

  EquipmentDetailSuccess copyWith({
    EquipmentDetailResponse? detail,
    List<StaffsResponse>? staffList,
    List<DcLocal>? dcList,
  }) {
    return EquipmentDetailSuccess(
      detail: detail ?? this.detail,
      staffList: staffList ?? this.staffList,
      dcList: dcList ?? this.dcList,
    );
  }
}

class EquipmentDetailFailure extends EquipmentDetailState {
  final String message;
  final int? errorCode;
  const EquipmentDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class EquipmentDetailUpdateSuccessfully extends EquipmentDetailState {}

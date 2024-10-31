part of 'repair_request_bloc.dart';

abstract class RepairRequestState extends Equatable {
  const RepairRequestState();

  @override
  List<Object?> get props => [];
}

class RepairRequestInitial extends RepairRequestState {}

class RepairRequestLoading extends RepairRequestState {}

class RepairRequestSuccess extends RepairRequestState {
  final String equipmentNo;
  final String driverName;
  final bool? isSuccess;
  const RepairRequestSuccess(
      {required this.equipmentNo, required this.driverName, this.isSuccess});
  @override
  List<Object?> get props => [equipmentNo, driverName, isSuccess];

  RepairRequestSuccess copyWith({
    String? equipmentNo,
    String? driverName,
    bool? isSuccess,
  }) {
    return RepairRequestSuccess(
      equipmentNo: equipmentNo ?? this.equipmentNo,
      driverName: driverName ?? this.driverName,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class RepairRequestFailure extends RepairRequestState {
  final String message;
  final int? errorCode;
  const RepairRequestFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

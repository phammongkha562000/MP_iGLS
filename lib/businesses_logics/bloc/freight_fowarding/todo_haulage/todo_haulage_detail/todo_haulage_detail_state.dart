part of 'todo_haulage_detail_bloc.dart';

abstract class ToDoHaulageDetailState extends Equatable {
  const ToDoHaulageDetailState();

  @override
  List<Object?> get props => [];
}

class ToDoHaulageDetailInitial extends ToDoHaulageDetailState {}

class ToDoHaulageDetailLoading extends ToDoHaulageDetailState {}

class ToDoHaulageDetailSuccess extends ToDoHaulageDetailState {
  final HaulageToDoDetail detail;
  final bool? isSuccess;
  final DateTime? expectedTime;
  final bool isTransfer;
  final List<EquipmentResponse> equipmentList;
  const ToDoHaulageDetailSuccess(
      {required this.detail,
      this.isSuccess,
      this.expectedTime,
      required this.isTransfer,
      required this.equipmentList});
  @override
  List<Object?> get props =>
      [detail, isSuccess, expectedTime, equipmentList, isTransfer];

  ToDoHaulageDetailSuccess copyWith({
    HaulageToDoDetail? detail,
    bool? isSuccess,
    DateTime? expectedTime,
    bool? isTransfer,
    List<EquipmentResponse>? equipmentList,
  }) {
    return ToDoHaulageDetailSuccess(
        isTransfer: isTransfer ?? this.isTransfer,
        detail: detail ?? this.detail,
        isSuccess: isSuccess ?? this.isSuccess,
        equipmentList: equipmentList ?? this.equipmentList,
        expectedTime: expectedTime ?? this.expectedTime);
  }
}

class ToDoHaulageDetailFailure extends ToDoHaulageDetailState {
  final String message;
  final int? errorCode;
  const ToDoHaulageDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class ToDoHaulageUpdateSuccess extends ToDoHaulageDetailState {
  final String mess;
  const ToDoHaulageUpdateSuccess({
    required this.mess,
  });
  @override
  List<Object?> get props => [mess];
}

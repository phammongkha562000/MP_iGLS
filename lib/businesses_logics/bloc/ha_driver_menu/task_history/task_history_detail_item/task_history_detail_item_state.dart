part of 'task_history_detail_item_bloc.dart';

abstract class TaskHistoryDetailItemState extends Equatable {
  const TaskHistoryDetailItemState();

  @override
  List<Object?> get props => [];
}

class TaskHistoryDetailItemInitial extends TaskHistoryDetailItemState {}

class TaskHistoryDetailItemLoading extends TaskHistoryDetailItemState {}

class TaskHistoryDetailItemSuccess extends TaskHistoryDetailItemState {
  final HistoryDetailItem detailItem;
  final bool? checkEquipment;
  final bool? saveSuccess;
  final List<EquipmentResponse> equipmentList;

  const TaskHistoryDetailItemSuccess(
      {required this.detailItem,
      this.checkEquipment,
      this.saveSuccess,
      required this.equipmentList});
  @override
  List<Object?> get props => [detailItem, checkEquipment, saveSuccess];

  TaskHistoryDetailItemSuccess copyWith(
      {HistoryDetailItem? detailItem,
      bool? checkEquipment,
      bool? saveSuccess,
      List<EquipmentResponse>? equipmentList}) {
    return TaskHistoryDetailItemSuccess(
      detailItem: detailItem ?? this.detailItem,
      checkEquipment: checkEquipment ?? this.checkEquipment,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      equipmentList: equipmentList ?? this.equipmentList,
    );
  }
}

class TaskHistoryDetailItemFailure extends TaskHistoryDetailItemState {
  final String message;
  final int? errorCode;
  const TaskHistoryDetailItemFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class CheckEquipmentFailure extends TaskHistoryDetailItemState {
  final String error;
  const CheckEquipmentFailure({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}

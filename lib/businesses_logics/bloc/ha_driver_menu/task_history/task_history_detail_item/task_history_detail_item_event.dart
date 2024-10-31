part of 'task_history_detail_item_bloc.dart';

abstract class TaskHistoryDetailItemEvent extends Equatable {
  const TaskHistoryDetailItemEvent();

  @override
  List<Object> get props => [];
}

class TaskHistoryDetailItemLoaded extends TaskHistoryDetailItemEvent {
  final int dtdId;
  final GeneralBloc generalBloc;
  const TaskHistoryDetailItemLoaded(
      {required this.dtdId, required this.generalBloc});
  @override
  List<Object> get props => [dtdId, generalBloc];
}

class UpdateWordOrderWithDataLoaded extends TaskHistoryDetailItemEvent {
  final int woTaskId;
  final String dataChange;
  final int type;
  final String sealNo;
  final GeneralBloc generalBloc;
  const UpdateWordOrderWithDataLoaded(
      {required this.woTaskId,
      required this.dataChange,
      required this.type,
      required this.sealNo,
      required this.generalBloc});
  @override
  List<Object> get props => [woTaskId, dataChange, type, sealNo, generalBloc];
}

class CheckEquipmentLoaded extends TaskHistoryDetailItemEvent {
  final String trailerNo;
  const CheckEquipmentLoaded({
    required this.trailerNo,
  });
  @override
  List<Object> get props => [trailerNo];
}

class UpdateTimeStart extends TaskHistoryDetailItemEvent {
  final int woTaskId;
  final String timeStartChange;
  const UpdateTimeStart({
    required this.woTaskId,
    required this.timeStartChange,
  });
  @override
  List<Object> get props => [woTaskId, timeStartChange];
}

class UpdateTimeEnd extends TaskHistoryDetailItemEvent {
  final int woTaskId;
  final String timeEndChange;
  const UpdateTimeEnd({
    required this.woTaskId,
    required this.timeEndChange,
  });
  @override
  List<Object> get props => [woTaskId, timeEndChange];
}

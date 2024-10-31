part of 'task_history_detail_bloc.dart';

abstract class TaskHistoryDetailState extends Equatable {
  const TaskHistoryDetailState();

  @override
  List<Object?> get props => [];
}

class TaskHistoryDetailInitial extends TaskHistoryDetailState {}

class TaskHistoryDetailLoading extends TaskHistoryDetailState {}

class TaskHistoryDetailSuccess extends TaskHistoryDetailState {
  final List<ListDetail> listDetail;
  final DailyTask dailyTask;
  const TaskHistoryDetailSuccess({
    required this.listDetail,
    required this.dailyTask,
  });
  @override
  List<Object> get props => [listDetail, dailyTask];
}

class TaskHistoryDetailFailure extends TaskHistoryDetailState {
  final String message;
  final int? errorCode;
  const TaskHistoryDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

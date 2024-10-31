part of 'task_history_bloc.dart';

abstract class TaskHistoryState extends Equatable {
  const TaskHistoryState();

  @override
  List<Object?> get props => [];
}

class TaskHistoryInitial extends TaskHistoryState {}

class TaskHistoryLoading extends TaskHistoryState {}

class TaskHistorySuccess extends TaskHistoryState {
  final DateTime? dateTime;
  final String eventStatus;
  final List<TaskHistoryResult> listTask;
  const TaskHistorySuccess(
      {this.dateTime, required this.listTask, required this.eventStatus});
  @override
  List<Object?> get props => [dateTime, listTask, eventStatus];

  TaskHistorySuccess copyWith(
      {DateTime? dateTime,
      List<TaskHistoryResult>? listTask,
      String? eventStatus}) {
    return TaskHistorySuccess(
        dateTime: dateTime ?? this.dateTime,
        listTask: listTask ?? this.listTask,
        eventStatus: eventStatus ?? this.eventStatus);
  }
}

class TaskHistoryFailure extends TaskHistoryState {
  final String message;
  final int? errorCode;
  const TaskHistoryFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

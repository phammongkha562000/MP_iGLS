part of 'task_history_bloc.dart';

abstract class TaskHistoryEvent extends Equatable {
  const TaskHistoryEvent();

  @override
  List<Object?> get props => [];
}

class TaskHistoryLoaded extends TaskHistoryEvent {
  final DateTime? dateTime;
  final String? status;
  final GeneralBloc generalBloc;
  const TaskHistoryLoaded({
    this.dateTime,
    this.status,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [dateTime, status, generalBloc];
}

class TaskHistoryPreviousMonthLoaded extends TaskHistoryEvent {
  final GeneralBloc generalBloc;
  const TaskHistoryPreviousMonthLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class TaskHistoryNextMonthLoaded extends TaskHistoryEvent {
  final GeneralBloc generalBloc;
  const TaskHistoryNextMonthLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class TaskHistoryFilterLoaded extends TaskHistoryEvent {
  final GeneralBloc generalBloc;

  final String? status;
  const TaskHistoryFilterLoaded({
    this.status,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [status, generalBloc];
}

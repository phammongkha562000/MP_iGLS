part of 'task_history_detail_bloc.dart';

abstract class TaskHistoryDetailEvent extends Equatable {
  const TaskHistoryDetailEvent();

  @override
  List<Object> get props => [];
}

class TaskHistoryDetailLoaded extends TaskHistoryDetailEvent {
  final int id;
  final GeneralBloc generalBloc;

  const TaskHistoryDetailLoaded({required this.id, required this.generalBloc});
  @override
  List<Object> get props => [id, generalBloc];
}

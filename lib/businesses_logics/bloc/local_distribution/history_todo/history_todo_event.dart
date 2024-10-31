part of 'history_todo_bloc.dart';

abstract class HistoryTodoEvent extends Equatable {
  const HistoryTodoEvent();

  @override
  List<Object?> get props => [];
}

class HistoryTodoLoaded extends HistoryTodoEvent {
  final DateTime date;
  final GeneralBloc generalBloc;

  const HistoryTodoLoaded({
    required this.date,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [date, generalBloc];
}

class HistoryTodoPaging extends HistoryTodoEvent {
  final GeneralBloc generalBloc;
  final DateTime date;

  const HistoryTodoPaging({
    required this.generalBloc,
    required this.date,
  });
  @override
  List<Object?> get props => [generalBloc, date];
}

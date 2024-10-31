part of 'history_todo_detail_simple_bloc.dart';

abstract class HistoryTodoDetailSimpleEvent extends Equatable {
  const HistoryTodoDetailSimpleEvent();

  @override
  List<Object?> get props => [];
}

class HistoryTodoDetailSimpleLoaded extends HistoryTodoDetailSimpleEvent {
  final String tripNo;
  final String tripClass;
  final GeneralBloc generalBloc;

  const HistoryTodoDetailSimpleLoaded({
    required this.tripNo,
    required this.tripClass,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [tripNo, tripClass, generalBloc];
}

part of 'history_todo_detail_normal_bloc.dart';

abstract class HistoryTodoDetailNormalEvent extends Equatable {
  const HistoryTodoDetailNormalEvent();

  @override
  List<Object> get props => [];
}

class HistoryTodoDetailNormalLoaded extends HistoryTodoDetailNormalEvent {
  final String tripNoNormal;
  final GeneralBloc generalBloc;
  const HistoryTodoDetailNormalLoaded(
      {required this.tripNoNormal, required this.generalBloc});
  @override
  List<Object> get props => [tripNoNormal, generalBloc];
}

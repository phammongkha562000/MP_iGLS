part of 'history_todo_bloc.dart';

abstract class HistoryTodoState extends Equatable {
  const HistoryTodoState();

  @override
  List<Object?> get props => [];
}

class HistoryTodoInitial extends HistoryTodoState {}

class HistoryTodoLoading extends HistoryTodoState {}
class HistoryTodoPagingLoading extends HistoryTodoState {}

class HistoryTodoSuccess extends HistoryTodoState {
  final List<HistoryTrip>? historyList;
  final int quantity;
  const HistoryTodoSuccess({this.historyList, required this.quantity});
  @override
  List<Object?> get props => [historyList, quantity];
}

class HistoryTodoFailure extends HistoryTodoState {
  final String message;
  final int? errorCode;
  const HistoryTodoFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

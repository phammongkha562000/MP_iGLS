part of 'history_todo_detail_simple_bloc.dart';

abstract class HistoryTodoDetailSimpleState extends Equatable {
  const HistoryTodoDetailSimpleState();

  @override
  List<Object?> get props => [];
}

class HistoryTodoDetailSimpleInitial extends HistoryTodoDetailSimpleState {}

class HistoryTodoDetailSimpleLoading extends HistoryTodoDetailSimpleState {}

class HistoryTodoDetailSimpleSuccess extends HistoryTodoDetailSimpleState {
  final ToDoTripDetailResponse? simpleTodoDetal;
  final List<SimpleOrderDetail>? listSimpleOrderDetail;
  final String? tripClass;
  const HistoryTodoDetailSimpleSuccess({
    this.simpleTodoDetal,
    this.listSimpleOrderDetail,
    this.tripClass,
  });
  @override
  List<Object?> get props =>
      [simpleTodoDetal, listSimpleOrderDetail, tripClass];
}

class HistoryTodoDetailSimpleFailure extends HistoryTodoDetailSimpleState {
  final String message;
  final int? errorCode;
  const HistoryTodoDetailSimpleFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

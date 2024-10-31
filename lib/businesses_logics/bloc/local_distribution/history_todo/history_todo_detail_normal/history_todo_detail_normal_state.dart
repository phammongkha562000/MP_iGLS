part of 'history_todo_detail_normal_bloc.dart';

abstract class HistoryTodoDetailNormalState extends Equatable {
  const HistoryTodoDetailNormalState();

  @override
  List<Object?> get props => [];
}

class HistoryTodoDetailNormalInitial extends HistoryTodoDetailNormalState {}

class HistoryTodoDetailNormalLoading extends HistoryTodoDetailNormalState {}

class HistoryTodoDetailNormalSuccess extends HistoryTodoDetailNormalState {
  final NormalTripDetailResponse tripNormal;
  final List<TripPlanOrder>? listTripPlanOrder;
  final List<List<TripPlanOrder>>? listGroupByOrder;
  final List<OrderNormal>? listOrder;
  const HistoryTodoDetailNormalSuccess(
      {required this.tripNormal,
      this.listTripPlanOrder,
      this.listOrder,
      this.listGroupByOrder});
  @override
  List<Object?> get props =>
      [tripNormal, listTripPlanOrder, listOrder, listGroupByOrder];
}

class HistoryTodoDetailNormalFailure extends HistoryTodoDetailNormalState {
  final String message;
  final int? errorCode;
  const HistoryTodoDetailNormalFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

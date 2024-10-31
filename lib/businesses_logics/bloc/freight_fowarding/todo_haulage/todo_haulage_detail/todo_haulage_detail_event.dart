part of 'todo_haulage_detail_bloc.dart';

abstract class ToDoHaulageDetailEvent extends Equatable {
  const ToDoHaulageDetailEvent();

  @override
  List<Object?> get props => [];
}

class ToDoHaulageDetailViewLoaded extends ToDoHaulageDetailEvent {
  final int woTaskId;
  final GeneralBloc generalBloc;
  const ToDoHaulageDetailViewLoaded(
      {required this.woTaskId, required this.generalBloc});
  @override
  List<Object> get props => [woTaskId, generalBloc];
}

class ToDoHaulageUpdateWorkOrderStatus extends ToDoHaulageDetailEvent {
  final String eventType;
  final DateTime? pickUpTime;
  final GeneralBloc generalBloc;
  const ToDoHaulageUpdateWorkOrderStatus(
      {required this.eventType, this.pickUpTime, required this.generalBloc});
  @override
  List<Object?> get props => [eventType, pickUpTime, generalBloc];
}

class ToDoHaulageUpdateTrailer extends ToDoHaulageDetailEvent {
  final String trailer;
  final GeneralBloc generalBloc;
  const ToDoHaulageUpdateTrailer(
      {required this.trailer, required this.generalBloc});
  @override
  List<Object> get props => [trailer, generalBloc];
}

class ToDoHaulageUpdateNote extends ToDoHaulageDetailEvent {
  final String note;
  final GeneralBloc generalBloc;
  const ToDoHaulageUpdateNote({required this.note, required this.generalBloc});
  @override
  List<Object> get props => [note, generalBloc];
}

class ToDoHaulageUpdateContainerSealNo extends ToDoHaulageDetailEvent {
  final String cntr;
  final String seal;
  final GeneralBloc generalBloc;
  const ToDoHaulageUpdateContainerSealNo(
      {required this.cntr, required this.seal, required this.generalBloc});
  @override
  List<Object> get props => [cntr, seal];
}

class TodoHaulageTime extends ToDoHaulageDetailEvent {}

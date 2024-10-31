part of 'update_todo_trip_bloc.dart';

abstract class UpdateTodoTripEvent extends Equatable {
  const UpdateTodoTripEvent();

  @override
  List<Object> get props => [];
}

class UpdateTodoTripViewLoaded extends UpdateTodoTripEvent {
  final String tripNo;
  final String contactCode;
  final GeneralBloc generalBloc;
  const UpdateTodoTripViewLoaded(
      {required this.tripNo,
      required this.contactCode,
      required this.generalBloc});
  @override
  List<Object> get props => [tripNo, contactCode, generalBloc];
}

class UpdateTodoTripSubmit extends UpdateTodoTripEvent {
  final String tripMemo;
  final String contactName;
  final GeneralBloc generalBloc;

  const UpdateTodoTripSubmit(
      {required this.tripMemo,
      required this.contactName,
      required this.generalBloc});
  @override
  List<Object> get props => [tripMemo, contactName, generalBloc];
}

class UpdateTodoTripStepStatus extends UpdateTodoTripEvent {
  final String eventType;
  final GeneralBloc generalBloc;
  const UpdateTodoTripStepStatus(
      {required this.eventType, required this.generalBloc});
  @override
  List<Object> get props => [eventType, generalBloc];
}

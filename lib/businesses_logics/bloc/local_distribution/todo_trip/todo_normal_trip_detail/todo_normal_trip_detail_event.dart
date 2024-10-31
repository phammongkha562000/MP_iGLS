part of 'todo_normal_trip_detail_bloc.dart';

abstract class ToDoNormalTripDetailEvent extends Equatable {
  const ToDoNormalTripDetailEvent();

  @override
  List<Object> get props => [];
}

class ToDoNormalTripDetailViewLoaded extends ToDoNormalTripDetailEvent {
  final String tripNo;
  final GeneralBloc generalBloc;
  const ToDoNormalTripDetailViewLoaded(
      {required this.tripNo,
      required this.generalBloc});
  @override
  List<Object> get props => [tripNo,  generalBloc];
}

class ToDoNormalTripUpdateStatus extends ToDoNormalTripDetailEvent {
  final int orgItemNo;
  final String eventType;
  final String tripNo;
  final GeneralBloc generalBloc;
  const ToDoNormalTripUpdateStatus(
      {required this.orgItemNo,
      required this.eventType,
      required this.tripNo,
      required this.generalBloc});
  @override
  List<Object> get props => [orgItemNo, eventType, tripNo, generalBloc];
}

class ToDoNormalTripUpdateOrgItemStatus extends ToDoNormalTripDetailEvent {
  final int orgItemNo;
  final String eventType;
  final String tripNo;
  final GeneralBloc generalBloc;
  const ToDoNormalTripUpdateOrgItemStatus(
      {required this.orgItemNo,
      required this.eventType,
      required this.tripNo,
      required this.generalBloc});
  @override
  List<Object> get props => [orgItemNo, eventType, tripNo, generalBloc];
}

// class ToDoNormalTripUpdateTripNo extends ToDoNormalTripDetailEvent {
//   final String tripNo;
//   const ToDoNormalTripUpdateTripNo({
//     required this.tripNo,
//   });
//   @override
//   List<Object> get props => [tripNo];
// }

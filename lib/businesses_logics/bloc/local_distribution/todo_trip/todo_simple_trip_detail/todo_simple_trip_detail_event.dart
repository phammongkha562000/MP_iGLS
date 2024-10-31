part of 'todo_simple_trip_detail_bloc.dart';

abstract class TodoSimpleTripDetailEvent extends Equatable {
  const TodoSimpleTripDetailEvent();

  @override
  List<Object?> get props => [];
}

class TodoSimpleTripDetailViewLoaded extends TodoSimpleTripDetailEvent {
  final String tripNo;
  final GeneralBloc generalBloc;
  const TodoSimpleTripDetailViewLoaded({
    required this.tripNo,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [tripNo, generalBloc];
}

//update pickup, start deli
class TodoSimpleTripDetailUpdateStatus extends TodoSimpleTripDetailEvent {
  final String tripNo;
  final String eventType;
  final int? orgItemNo;
  final int? orderId;
  final String? deliveryResult;
  final GeneralBloc generalBloc;
  const TodoSimpleTripDetailUpdateStatus(
      {required this.tripNo,
      required this.eventType,
      this.orgItemNo,
      this.orderId,
      this.deliveryResult,
      required this.generalBloc});
  @override
  List<Object?> get props =>
      [tripNo, eventType, orgItemNo, orderId, deliveryResult, generalBloc];
}

//update every item
class TodoSimpleTripDetailUpdateOrderStatus extends TodoSimpleTripDetailEvent {
  final String eventType;
  final String tripNo;
  final String deliveryResult;
  final String failReason;
  final int itemNo;
  final String orderId;
  final GeneralBloc generalBloc;
  const TodoSimpleTripDetailUpdateOrderStatus(
      {required this.eventType,
      required this.tripNo,
      required this.deliveryResult,
      required this.failReason,
      required this.itemNo,
      required this.orderId,
      required this.generalBloc});
  @override
  List<Object?> get props => [
        eventType,
        tripNo,
        deliveryResult,
        failReason,
        itemNo,
        orderId,
        generalBloc
      ];
}

class ToDoTripPickFailReason extends TodoSimpleTripDetailEvent {
  final String codeDesc;
  const ToDoTripPickFailReason({
    required this.codeDesc,
  });
  @override
  List<Object?> get props => [codeDesc];
}

//update location -i'm here
class TodoSimpleTripDetailUpdateStepTripStatus
    extends TodoSimpleTripDetailEvent {
  final GeneralBloc generalBloc;
  final String eventType;
  final String tripNo;
  final String orderId;
  const TodoSimpleTripDetailUpdateStepTripStatus(
      {required this.eventType,
      required this.tripNo,
      required this.orderId,
      required this.generalBloc});
  @override
  List<Object?> get props => [eventType, tripNo, orderId, generalBloc];
}

//take picture
class ToDoSimpleDetailTakeImage extends TodoSimpleTripDetailEvent {
  final String orderID;
  const ToDoSimpleDetailTakeImage({
    required this.orderID,
  });
  @override
  List<Object?> get props => [orderID];
}

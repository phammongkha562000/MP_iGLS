part of 'todo_normal_trip_detail_bloc.dart';

abstract class ToDoNormalTripDetailState extends Equatable {
  const ToDoNormalTripDetailState();

  @override
  List<Object?> get props => [];
}

class ToDoNormalTripDetailInitial extends ToDoNormalTripDetailState {}

class ToDoNormalTripDetailLoading extends ToDoNormalTripDetailState {}

class ToDoNormalTripDetailSuccess extends ToDoNormalTripDetailState {
  final ToDoNormalTripDetailResponse detail;
  final String tripNo;
  final bool? isSuccess;
  final List<List<OrgTrip>> groupList;
  final DateTime? expectedTime;

  const ToDoNormalTripDetailSuccess(
      {required this.detail,
      required this.tripNo,
      this.isSuccess,
      required this.groupList,
      this.expectedTime});
  @override
  List<Object?> get props =>
      [detail, tripNo, groupList, expectedTime, isSuccess];

  ToDoNormalTripDetailSuccess copyWith(
      {ToDoNormalTripDetailResponse? detail,
      String? tripNo,
      bool? isSuccess,
      DateTime? expectedTime,
      List<List<OrgTrip>>? groupList}) {
    return ToDoNormalTripDetailSuccess(
        detail: detail ?? this.detail,
        isSuccess: isSuccess ?? this.isSuccess,
        tripNo: tripNo ?? this.tripNo,
        expectedTime: expectedTime ?? this.expectedTime,
        groupList: groupList ?? this.groupList);
  }
}

class ToDoNormalTripDetailFailure extends ToDoNormalTripDetailState {
  final String message;
  final int? errorCode;
  const ToDoNormalTripDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

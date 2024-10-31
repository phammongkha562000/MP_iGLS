part of 'todo_simple_trip_detail_bloc.dart';

abstract class TodoSimpleTripDetailState extends Equatable {
  const TodoSimpleTripDetailState();

  @override
  List<Object?> get props => [];
}

class TodoSimpleTripDetailInitial extends TodoSimpleTripDetailState {}

class TodoSimpleTripDetailLoading extends TodoSimpleTripDetailState {}

class TodoSimpleTripDetailSuccess extends TodoSimpleTripDetailState {
  final ToDoTripDetailResponse detail;
  final List<StdCode>? listReason;
  final List<List<SimpleOrderDetail>> listGroup;
  final bool? isSuccess;
  final DateTime? expectedTime;
  // final XFile? imageFile;
  // final String? orderID;

  const TodoSimpleTripDetailSuccess({
    required this.detail,
    this.listReason,
    required this.listGroup,
    // this.imageFile,
    this.expectedTime,
    this.isSuccess,
    /*  this.orderID */
  });
  @override
  List<Object?> get props => [
        detail,
        listReason,
        isSuccess,
        expectedTime /*  imageFile, orderID */
      ];

  TodoSimpleTripDetailSuccess copyWith(
      {ToDoTripDetailResponse? detail,
      List<StdCode>? listReason,
      List<List<SimpleOrderDetail>>? listGroup,
      // XFile? imageFile,
      bool? isSuccess,
      DateTime? expectedTime
      /* String? orderID */
      }) {
    return TodoSimpleTripDetailSuccess(
        listGroup: listGroup ?? this.listGroup,
        detail: detail ?? this.detail,
        listReason: listReason ?? this.listReason,
        // imageFile: imageFile ?? this.imageFile,
        // orderID: orderID ?? this.orderID,
        expectedTime: expectedTime ?? this.expectedTime,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}

class TodoSimpleTripDetailFailure extends TodoSimpleTripDetailState {
  final String message;
  final int? errorCode;
  const TodoSimpleTripDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

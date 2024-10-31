part of 'todo_trip_bloc.dart';

abstract class ToDoTripState extends Equatable {
  const ToDoTripState();

  @override
  List<Object?> get props => [];
}

class ToDoTripInitial extends ToDoTripState {}

class ToDoTripLoading extends ToDoTripState {}

class TodoTripPagingLoading extends ToDoTripState {}

class ToDoTripSuccess extends ToDoTripState {
  final List<TodoResult> normalTripList;
  final List<TodoResult> simpleTripList;
  final List<TodoResult> normalTripPending;
  final List<TodoResult> simpleTripPending;
  final String equipmentNo;
  final bool? isSuccess;
  final String userID;
  final String url;
  final String serverWcf;
  final bool isAddTrip;
  final int quantity;
  final bool isPagingLoading;
  final String? dateCheckIn;

  const ToDoTripSuccess({
    required this.normalTripList,
    required this.simpleTripList,
    required this.normalTripPending,
    required this.simpleTripPending,
    required this.equipmentNo,
    this.isSuccess,
    required this.userID,
    required this.url,
    required this.serverWcf,
    required this.isAddTrip,
    required this.quantity,
    required this.isPagingLoading,
    this.dateCheckIn,
  });
  @override
  List<Object?> get props => [
        normalTripList,
        simpleTripList,
        normalTripPending,
        simpleTripPending,
        equipmentNo,
        isSuccess,
        userID,
        url,
        isAddTrip,
        quantity,
        isPagingLoading,
        dateCheckIn,
      ];

  ToDoTripSuccess copyWith(
      {List<TodoResult>? normalTripList,
      List<TodoResult>? simpleTripList,
      List<TodoResult>? normalTripPending,
      List<TodoResult>? simpleTripPending,
      String? equipmentNo,
      bool? isSuccess,
      String? userID,
      String? url,
      bool? isAddTrip,
      String? serverWcf,
      int? quantity,
      bool? isPagingLoading,
      String? dateCheckIn}) {
    return ToDoTripSuccess(
      normalTripList: normalTripList ?? this.normalTripList,
      simpleTripList: simpleTripList ?? this.simpleTripList,
      normalTripPending: normalTripPending ?? this.normalTripPending,
      simpleTripPending: simpleTripPending ?? this.simpleTripPending,
      equipmentNo: equipmentNo ?? this.equipmentNo,
     
      isSuccess: isSuccess ?? this.isSuccess,
      url: url ?? this.url,
      userID: userID ?? this.userID,
      serverWcf: serverWcf ?? this.serverWcf,
      isAddTrip: isAddTrip ?? this.isAddTrip,
      quantity: quantity ?? this.quantity,
      isPagingLoading: isPagingLoading ?? this.isPagingLoading,
      dateCheckIn: dateCheckIn ?? this.dateCheckIn,
    );
  }
}

class ToDoTripFailure extends ToDoTripState {
  final String message;
  final int? errorCode;
  const ToDoTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

// class ToDoGetUrlSuccess extends ToDoTripState {
//   final String url;
//   final String tripNo;
//   const ToDoGetUrlSuccess({
//     required this.url,
//     required this.tripNo,
//   });
//   @override
//   List<Object?> get props => [url, tripNo];
// }

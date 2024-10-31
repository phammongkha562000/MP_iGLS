part of 'update_todo_trip_bloc.dart';

abstract class UpdateTodoTripState extends Equatable {
  const UpdateTodoTripState();

  @override
  List<Object?> get props => [];
}

class UpdateTodoTripInitial extends UpdateTodoTripState {}

class UpdateTodoTripLoading extends UpdateTodoTripState {}

class UpdateTodoTripSuccess extends UpdateTodoTripState {
  final List<ContactLocal> contactList;
  final bool? isUpdate;
  final bool? isSuccess;
  final ToDoTripDetailResponse detail;
  final DateTime? expectedTime;

  const UpdateTodoTripSuccess(
      {required this.contactList,
      this.isUpdate,
      this.isSuccess,
      required this.detail,
      this.expectedTime});
  @override
  List<Object?> get props =>
      [contactList, isUpdate, isSuccess, detail, expectedTime];

  UpdateTodoTripSuccess copyWith(
      {List<ContactLocal>? contactList,
      bool? isUpdate,
      bool? isSuccess,
      ToDoTripDetailResponse? detail,
      DateTime? expectedTime}) {
    return UpdateTodoTripSuccess(
        contactList: contactList ?? this.contactList,
        isUpdate: isUpdate ?? this.isUpdate,
        isSuccess: isSuccess ?? this.isSuccess,
        detail: detail ?? this.detail,
        expectedTime: expectedTime ?? this.expectedTime);
  }
}

class UpdateTodoTripFailure extends UpdateTodoTripState {
  final String message;
  final int? errorCode;
  const UpdateTodoTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

part of 'todo_haulage_bloc.dart';

abstract class ToDoHaulageState extends Equatable {
  const ToDoHaulageState();

  @override
  List<Object?> get props => [];
}

class ToDoHaulageInitial extends ToDoHaulageState {}

class ToDoHaulageLoading extends ToDoHaulageState {}

class ToDoHaulagePagingLoading extends ToDoHaulageState {}

class ToDoHaulageSuccess extends ToDoHaulageState {
  final List<TodoHaulageResult> listToDo;
  final int quantity;
  final bool? isSuccess;

  final String? dateTime;
  const ToDoHaulageSuccess({
    required this.listToDo,
    required this.quantity,
    this.isSuccess,
    required this.dateTime,
  });
  @override
  List<Object?> get props => [listToDo, dateTime, isSuccess, quantity];

  ToDoHaulageSuccess copyWith(
      {List<TodoHaulageResult>? listToDo,
      List<TodoHaulageResult>? listToDoPending,
      int? quantity,
      String? dateTime,
      bool? isSuccess}) {
    return ToDoHaulageSuccess(
        listToDo: listToDo ?? this.listToDo,
        quantity: quantity ?? this.quantity,
        dateTime: dateTime ?? this.dateTime,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}

class ToDoHaulageFailure extends ToDoHaulageState {
  final String message;
  final int? errorCode;
  const ToDoHaulageFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

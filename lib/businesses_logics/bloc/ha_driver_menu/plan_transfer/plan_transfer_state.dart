part of 'plan_transfer_bloc.dart';

abstract class PlanTransferState extends Equatable {
  const PlanTransferState();

  @override
  List<Object?> get props => [];
}

class PlanTransferInitial extends PlanTransferState {}

class PlanTransferLoading extends PlanTransferState {}

class PlanTransferSuccess extends PlanTransferState {
  final List<TodoHaulageResult>? listToDo;
  final HaulageToDoDetail task;
  final bool? isSuccess;
  const PlanTransferSuccess(
      {this.listToDo, required this.task, this.isSuccess});
  @override
  List<Object?> get props => [listToDo, task, isSuccess];

  PlanTransferSuccess copyWith(
      {List<TodoHaulageResult>? listToDo,
      HaulageToDoDetail? task,
      bool? isSuccess}) {
    return PlanTransferSuccess(
      listToDo: listToDo ?? this.listToDo,
      task: task ?? this.task,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class PlanTransferSearchSuccess extends PlanTransferState {}

class PlanTransferFailure extends PlanTransferState {
  final String message;
  final int? errorCode;
  const PlanTransferFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

part of 'todo_haulage_bloc.dart';

abstract class ToDoHaulageEvent extends Equatable {
  const ToDoHaulageEvent();

  @override
  List<Object?> get props => [];
}

class ToDoHaulageViewLoaded extends ToDoHaulageEvent {
  final GeneralBloc generalBloc;
  const ToDoHaulageViewLoaded({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

class ToDoHaulageCheckIn extends ToDoHaulageEvent {
  final GeneralBloc generalBloc;
  const ToDoHaulageCheckIn({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class TodoHaulagePaging extends ToDoHaulageEvent {
  final GeneralBloc generalBloc;
  const TodoHaulagePaging({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

part of 'todo_trip_bloc.dart';

abstract class ToDoTripEvent extends Equatable {
  const ToDoTripEvent();

  @override
  List<Object?> get props => [];
}

class ToDoTripViewLoaded extends ToDoTripEvent {
  final String? pageId;
  final String? pageName;
  final GeneralBloc generalBloc;
  const ToDoTripViewLoaded(
      {this.pageId, this.pageName, required this.generalBloc});
  @override
  List<Object?> get props => [pageId, pageName, generalBloc];
}

class ToDoTripCheckIn extends ToDoTripEvent {
  final GeneralBloc generalBloc;
  const ToDoTripCheckIn({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class TodoTripPaging extends ToDoTripEvent {
  final GeneralBloc generalBloc;

  const TodoTripPaging({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

part of 'add_todo_trip_bloc.dart';

abstract class AddTodoTripEvent extends Equatable {
  const AddTodoTripEvent();

  @override
  List<Object?> get props => [];
}

class AddTodoTripViewLoaded extends AddTodoTripEvent {
  final GeneralBloc generalBloc;
  const AddTodoTripViewLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class AddTodoTripSubmit extends AddTodoTripEvent {
  final String? tripClassCode;
  final String? memo;
  final String contactCode;
  final GeneralBloc generalBloc;
  const AddTodoTripSubmit(
      {this.tripClassCode,
      this.memo,
      required this.contactCode,
      required this.generalBloc});
  @override
  List<Object?> get props => [tripClassCode, memo, contactCode, generalBloc];
}

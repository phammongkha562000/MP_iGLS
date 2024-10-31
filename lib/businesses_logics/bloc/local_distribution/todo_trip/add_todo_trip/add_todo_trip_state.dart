part of 'add_todo_trip_bloc.dart';

abstract class AddTodoTripState extends Equatable {
  const AddTodoTripState();

  @override
  List<Object?> get props => [];
}

class AddTodoTripInitial extends AddTodoTripState {}

class AddTodoTripLoading extends AddTodoTripState {}

class AddTodoTripSuccess extends AddTodoTripState {
  final List<ContactLocal> contactList;
  final List<ContactLocal> contactList2;
  final bool? isSuccess;
  final TodoResult? simpleTrip;

  const AddTodoTripSuccess(
      {required this.contactList,
      required this.contactList2,
      this.isSuccess,
      this.simpleTrip});
  @override
  List<Object?> get props => [contactList, contactList2, isSuccess, simpleTrip];

  AddTodoTripSuccess copyWith(
      {List<ContactLocal>? contactList,
      List<ContactLocal>? contactList2,
      TodoResult? simpleTrip,
      bool? isSuccess}) {
    return AddTodoTripSuccess(
        contactList: contactList ?? this.contactList,
        contactList2: contactList2 ?? this.contactList2,
        simpleTrip: simpleTrip ?? this.simpleTrip,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}

class AddTodoTripFailure extends AddTodoTripState {
  final String message;
  final int? errorCode;
  const AddTodoTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

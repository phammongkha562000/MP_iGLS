part of 'customer_home_bloc.dart';

abstract class CustomerHomeEvent extends Equatable {
  const CustomerHomeEvent();

  @override
  List<Object?> get props => [];
}

class CustomerHomeLoaded extends CustomerHomeEvent {
  final CustomerBloc customerBloc;
  const CustomerHomeLoaded({required this.customerBloc});
  @override
  List<Object> get props => [customerBloc];
}

class CustomerHomeAnnouncementLoaded extends CustomerHomeEvent {
  final CustomerBloc customerBloc;
  const CustomerHomeAnnouncementLoaded({
    required this.customerBloc,
  });
  @override
  List<Object> get props => [customerBloc];
}

class CustomerLogOut extends CustomerHomeEvent {
  final CustomerBloc customerBloc;
  const CustomerLogOut({
    required this.customerBloc,
  });
  @override
  List<Object> get props => [customerBloc];
}

part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class LogoutState extends CustomerState {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

part of 'customer_profile_bloc.dart';

sealed class CustomerProfileEvent extends Equatable {
  const CustomerProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileCustomerEvent extends CustomerProfileEvent {
  final UpdateCusProfileReq model;
  final CustomerBloc customerBloc;
  const UpdateProfileCustomerEvent(
      {required this.model, required this.customerBloc});
  @override
  List<Object> get props => [];
}

class ChangePassCustomerLoadEvent extends CustomerProfileEvent {}

class CusChangePasswordEvent extends CustomerProfileEvent {
  final CustomerBloc customerBloc;
  final String password;
  const CusChangePasswordEvent(
      {required this.customerBloc, required this.password});
  @override
  List<Object> get props => [];
}

class GetTimeLineEvent extends CustomerProfileEvent {
  final CustomerBloc customerBloc;
  const GetTimeLineEvent({required this.customerBloc});
  @override
  List<Object> get props => [];
}

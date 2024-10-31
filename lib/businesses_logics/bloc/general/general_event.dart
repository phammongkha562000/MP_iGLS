part of 'general_bloc.dart';

class GeneralEvent extends Equatable {
  const GeneralEvent();

  @override
  List<Object> get props => [];
}

class GeneralLogout extends GeneralEvent {}

class LoginToHub extends GeneralEvent {
  final String token;
  const LoginToHub({required this.token});
  @override
  List<Object> get props => [];
}

class AddInterceptor extends GeneralEvent {}

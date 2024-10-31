part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginViewLoaded extends LoginEvent {}

class LoginPressed extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final int mode;
  final GeneralBloc generalBloc;
  const LoginPressed(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode,
      required this.mode,
      required this.generalBloc});
  @override
  List<Object> get props =>
      [username, password, serverMode, remember, generalBloc, mode];
}

class CustomerLoginPressed extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final int mode;
  final CustomerBloc customerBloc;
  const CustomerLoginPressed(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode,
      required this.mode,
      required this.customerBloc});
  @override
  List<Object> get props =>
      [username, password, serverMode, remember, customerBloc, mode];
}

class LoginChangeServer extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final int mode;
  const LoginChangeServer(
      {required this.remember,
      required this.username,
      required this.password,
      required this.mode,
      required this.serverMode});
  @override
  List<Object> get props => [username, password, serverMode, remember, mode];
}

class LoginRemember extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final int mode;
  const LoginRemember(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode,
      required this.mode});
  @override
  List<Object> get props => [username, password, serverMode, remember, mode];
}

// class LoginValidate extends LoginEvent {
//   final bool? username;
//   final bool? password;
//   const LoginValidate({
//     this.username,
//     this.password,
//   });
//   @override
//   List<Object?> get props => [username, password];
// }
class LoginLanguage extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final int mode;

  const LoginLanguage({
    required this.remember,
    required this.username,
    required this.password,
    required this.serverMode,
    required this.mode,
  });
  @override
  List<Object> get props => [username, password, serverMode, remember, mode];
}

// class GetEquipment extends LoginEvent{

// }

class AuthLocalEvent extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final GeneralBloc generalBloc;
  final int mode;

  const AuthLocalEvent({
    required this.remember,
    required this.username,
    required this.password,
    required this.serverMode,
    required this.generalBloc,
    required this.mode,
  });
  @override
  List<Object> get props =>
      [username, password, serverMode, remember, generalBloc, mode];
}

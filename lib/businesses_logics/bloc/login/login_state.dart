part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadSuccess extends LoginState {
  final bool? isConnect;
  final String? serverMode;
  final String? userName;
  final String? password;
  final bool? isRemember;
  final bool? isBiometric;
  final String? biometrics;
  final String? mode;
  const LoginLoadSuccess(
      {this.isConnect,
      this.serverMode,
      this.userName,
      this.password,
      this.isRemember,
      this.isBiometric,
      this.biometrics,
      this.mode});
  @override
  List<Object?> get props => [
        isConnect,
        serverMode,
        userName,
        password,
        isRemember,
        isBiometric,
        biometrics,
        mode,
      ];

  LoginLoadSuccess copyWith(
      {bool? isConnect,
      String? serverMode,
      String? userName,
      String? password,
      bool? isRemember,
      bool? isBiometric,
      String? biometrics,
      String? locale,
      String? mode}) {
    return LoginLoadSuccess(
        isConnect: isConnect,
        serverMode: serverMode ?? this.serverMode,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        isRemember: isRemember ?? this.isRemember,
        isBiometric: isBiometric ?? this.isBiometric,
        biometrics: biometrics ?? this.biometrics,
        mode: mode ?? this.mode);
  }
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool isDefaultPass;
  const LoginSuccess({required this.isDefaultPass});
  @override
  List<Object?> get props => [isDefaultPass];
}

class LoginFailure extends LoginState {
  final String message;
  final int? errorCode;
  const LoginFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class LoginVersionOld extends LoginState {}

class CustomerLoginSuccess extends LoginState {}

class CustomerLoginFail extends LoginState {}

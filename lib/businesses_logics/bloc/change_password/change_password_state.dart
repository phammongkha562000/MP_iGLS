part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final bool? changePassSuccess;
  final String? currentPasword;
  const ChangePasswordSuccess({
    this.changePassSuccess,
    this.currentPasword,
  });
  @override
  List<Object?> get props => [currentPasword, changePassSuccess];
}
class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  final int? errorCode;
  const ChangePasswordFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

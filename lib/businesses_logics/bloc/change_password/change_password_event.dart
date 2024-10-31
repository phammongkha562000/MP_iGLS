part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordLoaded extends ChangePasswordEvent {
  final String? currentPasword;
  final String? newPassword;
  final String? confirmPassword;
  const ChangePasswordLoaded({
    this.currentPasword,
    this.newPassword,
    this.confirmPassword,
  });
  @override
  List<Object?> get props => [currentPasword, newPassword, confirmPassword];
}

class UpdatePassword extends ChangePasswordEvent {
  final String currentPasword;
  final String newPassword;
  final GeneralBloc generalBloc;
  const UpdatePassword(
      {required this.currentPasword,
      required this.newPassword,
      required this.generalBloc});
  @override
  List<Object?> get props => [currentPasword, newPassword, generalBloc];
}

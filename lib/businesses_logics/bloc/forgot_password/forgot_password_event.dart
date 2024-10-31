part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordViewLoaded extends ForgotPasswordEvent {
  final String username;
  final int tabMode;
  const ForgotPasswordViewLoaded(
      {required this.username, required this.tabMode});
  @override
  List<Object> get props => [username, tabMode];
}

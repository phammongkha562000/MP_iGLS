part of 'contact_bloc.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class ContactSuccess extends ContactState {
  final double appSize;

  const ContactSuccess({required this.appSize});
  @override
  List<Object?> get props => [appSize];
}

final class ContactFailure extends ContactState {
  final String message;
  final int? errorCode;

  const ContactFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

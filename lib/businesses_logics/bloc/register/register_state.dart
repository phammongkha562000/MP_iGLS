part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final bool isError;
  final String? error;
  const RegisterInitial({required this.isError, this.error});
  @override
  List<Object> get props => [isError, error!];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final dynamic error;
  const RegisterFailure({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}

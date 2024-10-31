part of 'driver_salary_bloc.dart';

abstract class DriverSalaryState extends Equatable {
  const DriverSalaryState();

  @override
  List<Object?> get props => [];
}

class DriverSalaryInitial extends DriverSalaryState {}

class DriverSalaryLoading extends DriverSalaryState {}

class DriverSalarySuccess extends DriverSalaryState {}

class DriverSalaryCheckPassSuccess extends DriverSalaryState {}

class DriverSalaryFailure extends DriverSalaryState {
  final String message;
  final int? errorCode;
  const DriverSalaryFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

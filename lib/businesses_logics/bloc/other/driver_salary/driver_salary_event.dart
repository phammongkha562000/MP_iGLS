part of 'driver_salary_bloc.dart';

abstract class DriverSalaryEvent extends Equatable {
  const DriverSalaryEvent();

  @override
  List<Object?> get props => [];
}

class DriverSalaryLoaded extends DriverSalaryEvent {
  final String? pageId;
  final String? pageName;
  const DriverSalaryLoaded({
    this.pageId,
    this.pageName,
  });

  @override
  List<Object?> get props => [pageId, pageName];
}

class DriverSalaryCheckPass extends DriverSalaryEvent {
  final String password;
  const DriverSalaryCheckPass({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}

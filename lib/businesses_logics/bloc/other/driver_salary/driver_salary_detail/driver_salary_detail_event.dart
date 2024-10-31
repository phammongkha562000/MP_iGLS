part of 'driver_salary_detail_bloc.dart';

abstract class DriverSalaryDetailEvent extends Equatable {
  const DriverSalaryDetailEvent();

  @override
  List<Object> get props => [];
}

class DriverSalaryDetailLoaded extends DriverSalaryDetailEvent {
  final GeneralBloc generalBloc;
  const DriverSalaryDetailLoaded({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class DriverSalaryDownAndGetFile extends DriverSalaryDetailEvent {
  final String filePath;
  final DriverSalaryPayload item;
  const DriverSalaryDownAndGetFile({
    required this.filePath,
    required this.item,
  });
  @override
  List<Object> get props => [filePath, item];
}

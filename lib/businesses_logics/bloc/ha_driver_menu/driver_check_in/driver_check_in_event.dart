part of 'driver_check_in_bloc.dart';

abstract class DriverCheckInEvent extends Equatable {
  const DriverCheckInEvent();

  @override
  List<Object?> get props => [];
}

class DriverCheckInViewLoaded extends DriverCheckInEvent {
  final DateTime? dateTime;
  final GeneralBloc generalBloc;
  const DriverCheckInViewLoaded({this.dateTime, required this.generalBloc});
  @override
  List<Object?> get props => [dateTime, generalBloc];
}

class DriverCheckInUpdate extends DriverCheckInEvent {
  final GeneralBloc generalBloc;
  const DriverCheckInUpdate({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

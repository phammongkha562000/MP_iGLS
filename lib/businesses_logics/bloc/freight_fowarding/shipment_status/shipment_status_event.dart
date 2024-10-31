part of 'shipment_status_bloc.dart';

abstract class ShipmentStatusEvent extends Equatable {
  const ShipmentStatusEvent();

  @override
  List<Object?> get props => [];
}

class ShipmentStatusLoaded extends ShipmentStatusEvent {
  final DateTime date;
  final String? blNo;
  final String? cntrNo;
  final GeneralBloc generalBloc;
  const ShipmentStatusLoaded(
      {required this.date, this.blNo, this.cntrNo, required this.generalBloc});

  @override
  List<Object?> get props => [date];
}

class ShipmentStatusNextDate extends ShipmentStatusEvent {
  final String? blNo;
  final String? cntrNo;
  final GeneralBloc generalBloc;

  const ShipmentStatusNextDate(
      {this.blNo, this.cntrNo, required this.generalBloc});
  @override
  List<Object?> get props => [blNo, cntrNo, generalBloc];
}

class ShipmentStatusPreviousDate extends ShipmentStatusEvent {
  final String? blNo;
  final String? cntrNo;
  final GeneralBloc generalBloc;

  const ShipmentStatusPreviousDate({
    this.blNo,
    this.cntrNo,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [blNo, cntrNo, generalBloc];
}

class ShipmentStatusPickDate extends ShipmentStatusEvent {
  final DateTime pickDate;
  final String? blNo;
  final String? cntrNo;
  final GeneralBloc generalBloc;

  const ShipmentStatusPickDate(
      {required this.pickDate,
      this.blNo,
      this.cntrNo,
      required this.generalBloc});
  @override
  List<Object?> get props => [blNo, cntrNo, pickDate, generalBloc];
}

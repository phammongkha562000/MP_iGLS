part of 'update_shuttle_trip_bloc.dart';

abstract class UpdateShuttleTripEvent extends Equatable {
  const UpdateShuttleTripEvent();

  @override
  List<Object?> get props => [];
}

class UpdateShuttleTripViewLoaded extends UpdateShuttleTripEvent {
  final ShuttleTripsResponse shuttleTrip;
  final DateTime? dateTime;
  final GeneralBloc generalBloc;
  const UpdateShuttleTripViewLoaded(
      {required this.shuttleTrip, this.dateTime, required this.generalBloc});
  @override
  List<Object?> get props => [shuttleTrip, dateTime, generalBloc];
}

class UpdateShuttleTripPressed extends UpdateShuttleTripEvent {
  final String fromId;
  final String invoiceNo;
  final String quantity;
  final String shipmentNo;
  final String sealNo;
  final String tripModeId;
  final String toId;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final GeneralBloc generalBloc;
  const UpdateShuttleTripPressed(
      {required this.fromId,
      required this.invoiceNo,
      required this.quantity,
      required this.shipmentNo,
      required this.sealNo,
      required this.tripModeId,
      required this.toId,
      required this.startDate,
      required this.startTime,
      required this.endDate,
      required this.endTime,
      required this.generalBloc});
  @override
  List<Object> get props => [
        fromId,
        invoiceNo,
        quantity,
        shipmentNo,
        sealNo,
        tripModeId,
        toId,
        startDate,
        startTime,
        endDate,
        endTime,
        generalBloc
      ];
}

class UpdateShuttleTripUpdateEndDate extends UpdateShuttleTripEvent {
  final String date;
  const UpdateShuttleTripUpdateEndDate({required this.date});
  @override
  List<Object> get props => [date];
}

class UpdateShuttleTripUpdateEndTime extends UpdateShuttleTripEvent {
  final String time;
  const UpdateShuttleTripUpdateEndTime({required this.time});
  @override
  List<Object> get props => [time];
}

class UpdateShuttleTripUpdateStartDate extends UpdateShuttleTripEvent {
  final String date;
  const UpdateShuttleTripUpdateStartDate({required this.date});
  @override
  List<Object> get props => [date];
}

class UpdateShuttleTripUpdateStartTime extends UpdateShuttleTripEvent {
  final String time;
  const UpdateShuttleTripUpdateStartTime({required this.time});
  @override
  List<Object> get props => [time];
}

class UpdateShuttleTripDelete extends UpdateShuttleTripEvent {
  final GeneralBloc generalBloc;
  const UpdateShuttleTripDelete({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

part of 'add_shuttle_trip_bloc.dart';

abstract class AddShuttleTripEvent extends Equatable {
  const AddShuttleTripEvent();

  @override
  List<Object?> get props => [];
}

class AddShuttleTripViewLoaded extends AddShuttleTripEvent {
  final ShuttleTripsResponse? shuttleTripPending;
  final GeneralBloc generalBloc;
  const AddShuttleTripViewLoaded(
      {required this.shuttleTripPending, required this.generalBloc});
  @override
  List<Object?> get props => [shuttleTripPending, generalBloc];
}

class AddShuttleTripStart extends AddShuttleTripEvent {
  final String fromId;
  final String invoiceNo;
  final String quantity;
  final String shipmentNo;
  final String sealNo;
  final String tripModeId;
  final String toId;
  final GeneralBloc generalBloc;
  const AddShuttleTripStart(
      {required this.fromId,
      required this.invoiceNo,
      required this.quantity,
      required this.shipmentNo,
      required this.sealNo,
      required this.tripModeId,
      required this.toId,
      required this.generalBloc});
  @override
  List<Object> get props => [
        fromId,
        invoiceNo,
        quantity,
        shipmentNo,
        sealNo,
        toId,
        tripModeId,
        generalBloc
      ];
}

class AddShuttleTripDone extends AddShuttleTripEvent {
  final String fromId;
  final String invoiceNo;
  final String quantity;
  final String shipmentNo;
  final String sealNo;
  final String tripModeId;
  final String toId;
  final GeneralBloc generalBloc;
  const AddShuttleTripDone(
      {required this.fromId,
      required this.invoiceNo,
      required this.quantity,
      required this.shipmentNo,
      required this.sealNo,
      required this.tripModeId,
      required this.toId,
      required this.generalBloc});
  @override
  List<Object> get props => [
        fromId,
        invoiceNo,
        quantity,
        shipmentNo,
        sealNo,
        toId,
        tripModeId,
        generalBloc
      ];
}

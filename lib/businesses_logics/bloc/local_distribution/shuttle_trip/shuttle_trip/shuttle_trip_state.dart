part of 'shuttle_trip_bloc.dart';

abstract class ShuttleTripState extends Equatable {
  const ShuttleTripState();

  @override
  List<Object?> get props => [];
}

class ShuttleTripInitial extends ShuttleTripState {}

class ShuttleTripLoading extends ShuttleTripState {}

class ShuttleTripSuccess extends ShuttleTripState {
  final DateTime dateTime;
  final List<ShuttleTripsResponse> shuttleTrips;
  final List<List<ShuttleTripsResponse>> groupShuttleTrips;
  final List<ShuttleTripsResponse> shuttleTripsByDate;
  const ShuttleTripSuccess(
      {required this.shuttleTrips,
      required this.dateTime,
      required this.groupShuttleTrips,
      required this.shuttleTripsByDate});
  @override
  List<Object?> get props =>
      [shuttleTrips, dateTime, shuttleTripsByDate, groupShuttleTrips];

  ShuttleTripSuccess copyWith(
      {List<ShuttleTripsResponse>? shuttleTrips,
      DateTime? dateTime,
      List<List<ShuttleTripsResponse>>? groupShuttleTrips,
      List<ShuttleTripsResponse>? shuttleTripsByDate}) {
    return ShuttleTripSuccess(
        shuttleTrips: shuttleTrips ?? this.shuttleTrips,
        dateTime: dateTime ?? this.dateTime,
        shuttleTripsByDate: shuttleTripsByDate ?? this.shuttleTripsByDate,
        groupShuttleTrips: groupShuttleTrips ?? this.groupShuttleTrips);
  }
}

class ShuttleTripFailure extends ShuttleTripState {
  final String message;
  final int? errorCode;
  const ShuttleTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

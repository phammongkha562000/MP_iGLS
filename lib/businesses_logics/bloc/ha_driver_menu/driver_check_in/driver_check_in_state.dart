part of 'driver_check_in_bloc.dart';

abstract class DriverCheckInState extends Equatable {
  const DriverCheckInState();

  @override
  List<Object?> get props => [];
}

class DriverCheckInInitial extends DriverCheckInState {}

class DriverCheckInLoading extends DriverCheckInState {}

class DriverCheckInSuccess extends DriverCheckInState {
  final String tractor;
  final String driverId;
  final String? dateTime;
  final bool? isSuccess;

  const DriverCheckInSuccess({
    required this.tractor,
    this.dateTime,
    required this.driverId,
    this.isSuccess,
  });
  @override
  List<Object?> get props => [
        tractor,
        driverId,
        dateTime,
        isSuccess,
      ];

  DriverCheckInSuccess copyWith({
    String? tractor,
    String? driverId,
    String? dateTime,
    bool? isSuccess,
    bool? updateSuccess,
  }) {
    return DriverCheckInSuccess(
      tractor: tractor ?? this.tractor,
      driverId: driverId ?? this.driverId,
      dateTime: dateTime ?? this.dateTime,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class DriverCheckInFailure extends DriverCheckInState {
  final String message;
  final int? errorCode;
  const DriverCheckInFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

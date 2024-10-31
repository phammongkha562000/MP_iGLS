part of 'manual_driver_closing_bloc.dart';

abstract class ManualDriverClosingEvent extends Equatable {
  const ManualDriverClosingEvent();

  @override
  List<Object?> get props => [];
}

class ManualDriverClosingViewLoaded extends ManualDriverClosingEvent {
  final GeneralBloc generalBloc;
  const ManualDriverClosingViewLoaded({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

class ManualDriverClosingPickDate extends ManualDriverClosingEvent {
  final DateTime date;
  const ManualDriverClosingPickDate({
    required this.date,
  });
  @override
  List<Object> get props => [date];
}

class ManualDriverClosingSaveWithoutTripNo extends ManualDriverClosingEvent {
  final GeneralBloc generalBloc;
  final DateTime tripDate;
  final String tripNo;
  final double mileStart;
  final double mileEnd;
  final String tripRoute;
  final double allowance;
  final double mealAllowance;
  final double tollFee;
  final double loadUnloadCost;
  final double othersFee;
  final double actualTotal;
  final String driverMemo;
  final String contact;
  const ManualDriverClosingSaveWithoutTripNo(
      {required this.tripDate,
      required this.generalBloc,
      required this.tripNo,
      required this.mileStart,
      required this.mileEnd,
      required this.tripRoute,
      required this.allowance,
      required this.mealAllowance,
      required this.tollFee,
      required this.loadUnloadCost,
      required this.othersFee,
      required this.actualTotal,
      required this.driverMemo,
      required this.contact});
  @override
  List<Object> get props => [
        tripDate,
        tripNo,
        mileStart,
        mileEnd,
        tripRoute,
        allowance,
        mealAllowance,
        tollFee,
        loadUnloadCost,
        othersFee,
        actualTotal,
        driverMemo,
        contact,
        generalBloc
      ];
}

class ManualDriverClosingSaveWithTripNo extends ManualDriverClosingEvent {
  final GeneralBloc generalBloc;
  final int? dDCId;
  final String tripDate;
  final String tripNo;
  final double mileStart;
  final double mileEnd;
  final String tripRoute;
  final double allowance;
  final double mealAllowance;
  final double tollFee;
  final double loadUnloadCost;
  final double othersFee;
  final double actualTotal;
  final String driverMemo;
  final String driverTripType;
  final String contactCode;
  const ManualDriverClosingSaveWithTripNo(
      {this.dDCId,
      required this.generalBloc,
      required this.tripDate,
      required this.tripNo,
      required this.mileStart,
      required this.mileEnd,
      required this.tripRoute,
      required this.allowance,
      required this.mealAllowance,
      required this.tollFee,
      required this.loadUnloadCost,
      required this.othersFee,
      required this.actualTotal,
      required this.driverMemo,
      required this.contactCode,
      required this.driverTripType});
  @override
  List<Object?> get props => [
        dDCId,
        tripDate,
        tripNo,
        mileStart,
        mileEnd,
        tripRoute,
        allowance,
        mealAllowance,
        tollFee,
        loadUnloadCost,
        othersFee,
        actualTotal,
        driverMemo,
        driverTripType,
        generalBloc,
        contactCode
      ];
}

part of 'driver_closing_history_detail_bloc.dart';

sealed class DriverClosingHistoryDetailEvent extends Equatable {
  const DriverClosingHistoryDetailEvent();

  @override
  List<Object?> get props => [];
}

class DriverClosingHistoryDetailViewLoaded
    extends DriverClosingHistoryDetailEvent {
  final int dDCId;
  final GeneralBloc generalBloc;
  const DriverClosingHistoryDetailViewLoaded({
    required this.dDCId,
    required this.generalBloc,
  });
}

class DriverClosingHistoryUpdate extends DriverClosingHistoryDetailEvent {
  final GeneralBloc generalBloc;
  final UpdateDriverDailyClosingReq content;

  const DriverClosingHistoryUpdate(
      {required this.generalBloc, required this.content});
  @override
  List<Object?> get props => [generalBloc, content];
}

// class DriverClosingHistorySaveWithoutTripNo
//     extends DriverClosingHistoryDetailEvent {
//   final GeneralBloc generalBloc;
//   final DateTime tripDate;
//   final String tripNo;
//   final double mileStart;
//   final double mileEnd;
//   final String tripRoute;
//   final double allowance;
//   final double mealAllowance;
//   final double tollFee;
//   final double loadUnloadCost;
//   final double othersFee;
//   final double actualTotal;
//   final String driverMemo;
//   final String contact;
//   const DriverClosingHistorySaveWithoutTripNo(
//       {required this.tripDate,
//       required this.generalBloc,
//       required this.tripNo,
//       required this.mileStart,
//       required this.mileEnd,
//       required this.tripRoute,
//       required this.allowance,
//       required this.mealAllowance,
//       required this.tollFee,
//       required this.loadUnloadCost,
//       required this.othersFee,
//       required this.actualTotal,
//       required this.driverMemo,
//       required this.contact});
//   @override
//   List<Object> get props => [
//         tripDate,
//         tripNo,
//         mileStart,
//         mileEnd,
//         tripRoute,
//         allowance,
//         mealAllowance,
//         tollFee,
//         loadUnloadCost,
//         othersFee,
//         actualTotal,
//         driverMemo,
//         contact,
//         generalBloc
//       ];
// }

// class DriverClosingHistorySaveWithTripNo
//     extends DriverClosingHistoryDetailEvent {
//   final GeneralBloc generalBloc;
//   final int dDCId;
//   final String tripDate;
//   final String tripNo;
//   final double mileStart;
//   final double mileEnd;
//   final String tripRoute;
//   final double allowance;
//   final double mealAllowance;
//   final double tollFee;
//   final double loadUnloadCost;
//   final double othersFee;
//   final double actualTotal;
//   final String driverMemo;
//   final String driverTripType;
//   final String contactCode;
//   const DriverClosingHistorySaveWithTripNo(
//       {required this.dDCId,
//       required this.generalBloc,
//       required this.tripDate,
//       required this.tripNo,
//       required this.mileStart,
//       required this.mileEnd,
//       required this.tripRoute,
//       required this.allowance,
//       required this.mealAllowance,
//       required this.tollFee,
//       required this.loadUnloadCost,
//       required this.othersFee,
//       required this.actualTotal,
//       required this.driverMemo,
//       required this.contactCode,
//       required this.driverTripType});
//   @override
//   List<Object?> get props => [
//         dDCId,
//         tripDate,
//         tripNo,
//         mileStart,
//         mileEnd,
//         tripRoute,
//         allowance,
//         mealAllowance,
//         tollFee,
//         loadUnloadCost,
//         othersFee,
//         actualTotal,
//         driverMemo,
//         driverTripType,
//         generalBloc,
//         contactCode
//       ];
// }

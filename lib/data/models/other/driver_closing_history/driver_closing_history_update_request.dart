class UpdateDriverDailyClosingReq {
  final int ddcId;
  final String userId;
  final String closeMemo;
  final String driverTripType;
  final double advAllowance;
  final double advMealAllowance;
  final double advTollFee;
  final double advLoadUnloadCost;
  final double advOthersFee;
  final double advCashAdvance;
  final double mileStart;
  final double mileEnd;
  final double allowance;
  final double mealAllowance;
  final double tollFee;
  final double loadUnloadCost;
  final double othersFee;
  final double actualTotal;
  final String cashAdavanceMemo;
  final String tripRoute;
  final String driverMemo;
  final String tripDate;
  final String equipmentNo;

  UpdateDriverDailyClosingReq(
      {required this.ddcId,
      required this.userId,
      required this.closeMemo,
      required this.driverTripType,
      required this.advAllowance,
      required this.advMealAllowance,
      required this.advTollFee,
      required this.advLoadUnloadCost,
      required this.advOthersFee,
      required this.advCashAdvance,
      required this.mileStart,
      required this.mileEnd,
      required this.allowance,
      required this.mealAllowance,
      required this.tollFee,
      required this.loadUnloadCost,
      required this.othersFee,
      required this.actualTotal,
      required this.cashAdavanceMemo,
      required this.tripRoute,
      required this.driverMemo,
      required this.tripDate,
      required this.equipmentNo});

  Map<String, dynamic> toJson() => {
        "DDCId": ddcId,
        "UserId": userId,
        "CloseMemo": closeMemo,
        "DriverTripType": driverTripType,
        "AdvAllowance": advAllowance,
        "AdvMealAllowance": advMealAllowance,
        "AdvTollFee": advTollFee,
        "AdvLoadUnloadCost": advLoadUnloadCost,
        "AdvOthersFee": advOthersFee,
        "AdvCashAdvance": advCashAdvance,
        "MileStart": mileStart,
        "MileEnd": mileEnd,
        "Allowance": allowance,
        "MealAllowance": mealAllowance,
        "TollFee": tollFee,
        "LoadUnloadCost": loadUnloadCost,
        "OthersFee": othersFee,
        "ActualTotal": actualTotal,
        "CashAdavanceMemo": cashAdavanceMemo,
        "TripRoute": tripRoute,
        "DriverMemo": driverMemo,
        "TripDate": tripDate,
        "EquipmentNo": equipmentNo,
      };
}

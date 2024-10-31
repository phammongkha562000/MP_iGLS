class DriverDailyClosingWithoutTripNoRequest {
  final String tripDate;
  final String contactCode;
  final String tripNo;
  final String driverId;
  final String equipmentNo;
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
  final String userId;
  final int? dDCId;
  DriverDailyClosingWithoutTripNoRequest({
    this.dDCId,
    required this.tripDate,
    required this.contactCode,
    required this.tripNo,
    required this.driverId,
    required this.equipmentNo,
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
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DDCId': dDCId,
      'TripDate': tripDate,
      'ContactCode': contactCode,
      'TripNo': tripNo,
      'DriverId': driverId,
      'EquipmentNo': equipmentNo,
      'MileStart': mileStart,
      'MileEnd': mileEnd,
      'TripRoute': tripRoute,
      'Allowance': allowance,
      'MealAllowance': mealAllowance,
      'TollFee': tollFee,
      'LoadUnloadCost': loadUnloadCost,
      'OthersFee': othersFee,
      'ActualTotal': actualTotal,
      'DriverMemo': driverMemo,
      'UserId': userId,
    };
  }
}

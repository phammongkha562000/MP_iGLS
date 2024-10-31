class DriverDailyClosingWithTripNoRequest {
  final int? dDCId;
  final String tripDate;
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
  final String driverTripType;
  final String contactCode;

  DriverDailyClosingWithTripNoRequest(
      {this.dDCId,
      required this.tripDate,
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
      required this.driverTripType,
      required this.contactCode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DDCId': dDCId,
      'DriverTripType': driverTripType,
      'TripDate': tripDate,
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
      'ContactCode': contactCode,
    };
  }
}

class DriverDailyClosingDetailResponse {
  int? dDCId;
  String? contactCode;
  String? contactName;
  String? tripNo;
  String? driverId;
  String? driverName;
  String? equipmentNo;
  String? tripDate;
  String? driverTripType;
  String? createDate;
  String? createUser;
  String? updateDate;
  String? updateUser;
  String? closingStatus;
  double? advAllowance;
  double? advMealAllowance;
  double? advTollFee;
  double? advLoadUnloadCost;
  double? advOthersFee;
  double? advCashAdvance;
  String? cashAdavanceMemo;
  double? mileStart;
  double? mileEnd;
  double? allowance;
  double? mealAllowance;
  double? tollFee;
  double? othersFee;
  double? loadUnLoadCost;
  double? acualTotal;
  String? driverMemo;
  String? driverPostDate;
  String? closingStatusDesc;
  String? driverTripTypeDesc;
  String? closeMemo;
  String? closeDate;
  String? shipToes;
  String? triproute;
  DriverDailyClosingDetailResponse({
    this.dDCId,
    this.contactCode,
    this.contactName,
    this.tripNo,
    this.driverId,
    this.driverName,
    this.equipmentNo,
    this.tripDate,
    this.driverTripType,
    this.createDate,
    this.createUser,
    this.updateDate,
    this.updateUser,
    this.closingStatus,
    this.advAllowance,
    this.advMealAllowance,
    this.advTollFee,
    this.advLoadUnloadCost,
    this.advOthersFee,
    this.advCashAdvance,
    this.cashAdavanceMemo,
    this.mileStart,
    this.mileEnd,
    this.allowance,
    this.mealAllowance,
    this.tollFee,
    this.othersFee,
    this.loadUnLoadCost,
    this.acualTotal,
    this.driverMemo,
    this.driverPostDate,
    this.closingStatusDesc,
    this.driverTripTypeDesc,
    this.closeMemo,
    this.closeDate,
    this.shipToes,
    this.triproute,
  });

  factory DriverDailyClosingDetailResponse.fromMap(Map<String, dynamic> map) {
    return DriverDailyClosingDetailResponse(
      dDCId: map['DDCId'] != null ? map['DDCId'] as int : null,
      contactCode:
          map['ContactCode'] != null ? map['ContactCode'] as String : null,
      contactName:
          map['ContactName'] != null ? map['ContactName'] as String : null,
      tripNo: map['TripNo'] != null ? map['TripNo'] as String : null,
      driverId: map['DriverId'] != null ? map['DriverId'] as String : null,
      driverName:
          map['DriverName'] != null ? map['DriverName'] as String : null,
      equipmentNo:
          map['EquipmentNo'] != null ? map['EquipmentNo'] as String : null,
      tripDate: map['TripDate'] != null ? map['TripDate'] as String : null,
      driverTripType: map['DriverTripType'] != null
          ? map['DriverTripType'] as String
          : null,
      createDate:
          map['CreateDate'] != null ? map['CreateDate'] as String : null,
      createUser:
          map['CreateUser'] != null ? map['CreateUser'] as String : null,
      updateDate:
          map['UpdateDate'] != null ? map['UpdateDate'] as String : null,
      updateUser:
          map['UpdateUser'] != null ? map['UpdateUser'] as String : null,
      closingStatus:
          map['ClosingStatus'] != null ? map['ClosingStatus'] as String : null,
      advAllowance:
          map['AdvAllowance'] != null ? map['AdvAllowance'] as double : null,
      advMealAllowance: map['AdvMealAllowance'] != null
          ? map['AdvMealAllowance'] as double
          : null,
      advTollFee:
          map['AdvTollFee'] != null ? map['AdvTollFee'] as double : null,
      advLoadUnloadCost: map['AdvLoadUnloadCost'] != null
          ? map['AdvLoadUnloadCost'] as double
          : null,
      advOthersFee:
          map['AdvOthersFee'] != null ? map['AdvOthersFee'] as double : null,
      advCashAdvance: map['AdvCashAdvance'] != null
          ? map['AdvCashAdvance'] as double
          : null,
      cashAdavanceMemo: map['CashAdavanceMemo'] != null
          ? map['CashAdavanceMemo'] as String
          : null,
      mileStart: map['MileStart'] != null ? map['MileStart'] as double : null,
      mileEnd: map['MileEnd'] != null ? map['MileEnd'] as double : null,
      allowance: map['Allowance'] != null ? map['Allowance'] as double : null,
      mealAllowance:
          map['MealAllowance'] != null ? map['MealAllowance'] as double : null,
      tollFee: map['TollFee'] != null ? map['TollFee'] as double : null,
      othersFee: map['OthersFee'] != null ? map['OthersFee'] as double : null,
      loadUnLoadCost: map['LoadUnLoadCost'] != null
          ? map['LoadUnLoadCost'] as double
          : null,
      acualTotal:
          map['AcualTotal'] != null ? map['AcualTotal'] as double : null,
      driverMemo:
          map['DriverMemo'] != null ? map['DriverMemo'] as String : null,
      driverPostDate: map['DriverPostDate'] != null
          ? map['DriverPostDate'] as String
          : null,
      closingStatusDesc: map['ClosingStatusDesc'] != null
          ? map['ClosingStatusDesc'] as String
          : null,
      driverTripTypeDesc: map['DriverTripTypeDesc'] != null
          ? map['DriverTripTypeDesc'] as String
          : null,
      closeMemo: map['CloseMemo'] != null ? map['CloseMemo'] as String : null,
      closeDate: map['CloseDate'] != null ? map['CloseDate'] as String : null,
      shipToes: map['ShipToes'] != null ? map['ShipToes'] as String : null,
      triproute: map['TripRoute'] != null ? map['TripRoute'] as String : null,
    );
  }
}

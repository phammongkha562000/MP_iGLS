class DriverClosingHistoryResponse {
  int? dDCId;
  String? tripNo;
  String? contactCode;
  String? tripDate;
  String? staffName;
  String? equipmentNo;
  double? advCashAdvance;
  String? driverPostDate;
  double? acualTotal;
  String? driverTripType;
  String? driverTripTypeDesc;
  String? closingStatus;
  String? closingStatusDesc;
  String? closeDate;
  DriverClosingHistoryResponse({
    this.dDCId,
    this.tripNo,
    this.contactCode,
    this.tripDate,
    this.staffName,
    this.equipmentNo,
    this.advCashAdvance,
    this.driverPostDate,
    this.acualTotal,
    this.driverTripType,
    this.driverTripTypeDesc,
    this.closingStatus,
    this.closingStatusDesc,
    this.closeDate,
  });

  factory DriverClosingHistoryResponse.fromMap(Map<String, dynamic> map) {
    return DriverClosingHistoryResponse(
      dDCId: map['DDCId'] != null ? map['DDCId'] as int : null,
      tripNo: map['TripNo'] != null ? map['TripNo'] as String : null,
      contactCode:
          map['ContactCode'] != null ? map['ContactCode'] as String : null,
      tripDate: map['TripDate'] != null ? map['TripDate'] as String : null,
      staffName: map['StaffName'] != null ? map['StaffName'] as String : null,
      equipmentNo:
          map['EquipmentNo'] != null ? map['EquipmentNo'] as String : null,
      advCashAdvance: map['AdvCashAdvance'] != null
          ? map['AdvCashAdvance'] as double
          : null,
      driverPostDate: map['DriverPostDate'] != null
          ? map['DriverPostDate'] as String
          : null,
      acualTotal:
          map['AcualTotal'] != null ? map['AcualTotal'] as double : null,
      driverTripType: map['DriverTripType'] != null
          ? map['DriverTripType'] as String
          : null,
      driverTripTypeDesc: map['DriverTripTypeDesc'] != null
          ? map['DriverTripTypeDesc'] as String
          : null,
      closingStatus:
          map['ClosingStatus'] != null ? map['ClosingStatus'] as String : null,
      closingStatusDesc: map['ClosingStatusDesc'] != null
          ? map['ClosingStatusDesc'] as String
          : null,
      closeDate: map['CloseDate'] != null ? map['CloseDate'] as String : null,
    );
  }
}

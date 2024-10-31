class DriverClosingHistoryRequest {
  final String tripDateF;
  final String tripDateT;
  final String driverTripType;
  final String tripNo;
  final String orderNo;
  final String driverId;
  final String closingStatus;
  final String? contactCode;
  final String companyId;
  DriverClosingHistoryRequest({
    required this.tripDateF,
    required this.tripDateT,
    required this.driverTripType,
    required this.tripNo,
    required this.orderNo,
    required this.driverId,
    required this.closingStatus,
    required this.contactCode,
    required this.companyId,
  });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'TripDateF': tripDateF,
      'TripDateT': tripDateT,
      'DriverTripType': driverTripType,
      'TripNo': tripNo,
      'OrderNo': orderNo,
      'DriverId': driverId,
      'ClosingStatus': closingStatus,
      'ContactCode': contactCode,
      'CompanyId': companyId,
    };
  }

  
}

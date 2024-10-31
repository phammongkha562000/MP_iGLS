class SimpleTripRequest {
  final String? tripNo;
  final String? eTP;
  final String? eTA;
  final String? eTD;
  final String? createUser;
  final String? equipmentCode;
  final String? equipmentDesc;
  final String? driverDesc;
  final String? driverId;
  final String? aTP;
  final String? completeTime;
  final String? tripStatus;
  final String? dCCode;
  final String tripMemo;
  final String? equipTypeNo;
  final String? contactCode;
  final String? driverTripType;
  final String? driverTripTypeDesc;
  final String? iconStatus;
  SimpleTripRequest({
    this.tripNo,
    this.eTP,
    this.eTA,
    this.eTD,
    this.createUser,
    this.equipmentCode,
    this.equipmentDesc,
    this.driverDesc,
    this.driverId,
    this.aTP,
    this.completeTime,
    this.tripStatus,
    this.dCCode,
    required this.tripMemo,
    this.equipTypeNo,
    this.contactCode,
    this.driverTripType,
    this.driverTripTypeDesc,
    this.iconStatus,
  });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'TripNo': tripNo,
      'ETP': eTP,
      'ETA': eTA,
      'ETD': eTD,
      'CreateUser': createUser,
      'EquipmentCode': equipmentCode,
      'EquipmentDesc': equipmentDesc,
      'DriverDesc': driverDesc,
      'DriverId': driverId,
      'ATP': aTP,
      'CompleteTime': completeTime,
      'TripStatus': tripStatus,
      'DCCode': dCCode,
      'TripMemo': tripMemo,
      'EquipTypeNo': equipTypeNo,
      'ContactCode': contactCode,
      'DriverTripType': driverTripType,
      'DriverTripTypeDesc': driverTripTypeDesc,
      'IconStatus': iconStatus,
    };
  }

  
}

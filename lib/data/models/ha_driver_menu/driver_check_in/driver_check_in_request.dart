class DriverCheckInRequest {
  final String equipmentCode;
  final String dcCode;
  final String driverId;
  final String userId;
  final String onDate;
  DriverCheckInRequest({
    required this.equipmentCode,
    required this.dcCode,
    required this.driverId,
    required this.userId,
    required this.onDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'EquipmentCode': equipmentCode,
      'DCCode': dcCode,
      'DriverId': driverId,
      'UserId': userId,
      'OnDate': onDate,
    };
  }
}

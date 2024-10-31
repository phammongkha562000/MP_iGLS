class PlanTransferRequest {
  final String woNo;
  final int woTaskId;
  final String priEquipmentCode;
  final String secEquipmentCode;
  final String createUser;
  final String driverId;
  final String dtdId;
  final String dtId;
  final int dtIdChanged;
  PlanTransferRequest({
    required this.woNo,
    required this.woTaskId,
    required this.priEquipmentCode,
    required this.secEquipmentCode,
    required this.createUser,
    required this.driverId,
    required this.dtdId,
    required this.dtId,
    required this.dtIdChanged,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'WONo': woNo,
      'WOTaskId': woTaskId,
      'PriEquipmentCode': priEquipmentCode,
      'SecEquipmentCode': secEquipmentCode,
      'CreateUser': createUser,
      'DriverId': driverId,
      'DTDId': dtdId,
      'DTId': dtId,
      'DTIdChanged': dtIdChanged,
    };
  }
}

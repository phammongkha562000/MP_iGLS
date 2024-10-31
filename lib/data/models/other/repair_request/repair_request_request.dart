class RepairRequestRequest {
  final String? requestDate;
  final String dcCode;
  final String equipmentCode;
  final String staffUserId;
  final int currentMileage;
  final String issueDesc;
  final String createUser;
  final String? reqNo;
  RepairRequestRequest({
    this.requestDate,
    required this.dcCode,
    required this.equipmentCode,
    required this.staffUserId,
    required this.currentMileage,
    required this.issueDesc,
    required this.createUser,
    this.reqNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DCCode': dcCode,
      'EquipmentCode': equipmentCode,
      'StaffUserId': staffUserId,
      'CurrentMileage': currentMileage,
      'IssueDesc': issueDesc,
      'CreateUser': createUser,
      'ReqNo': reqNo,
    };
  }
}

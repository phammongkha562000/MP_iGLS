class TrailerPendingRes {
  String? equipStatus;
  String? equipTypeDesc;
  String? equipmentType;
  dynamic expireDate;
  String? lastCYName;
  String? lastCheckDate;
  String? lastRemark;
  String? trailerNumber;
  String? lastCNTR;
  String? lastContactCode;

  TrailerPendingRes(
      {this.equipStatus,
      this.equipTypeDesc,
      this.equipmentType,
      this.expireDate,
      this.lastCYName,
      this.lastCheckDate,
      this.lastRemark,
      this.trailerNumber,
      this.lastCNTR,
      this.lastContactCode});

  TrailerPendingRes.fromJson(Map<String, dynamic> json) {
    equipStatus = json['EquipStatus'];
    equipTypeDesc = json['EquipTypeDesc'];
    equipmentType = json['EquipmentType'];
    expireDate = json['ExpireDate'];
    lastCYName = json['LastCYName'];
    lastCheckDate = json['LastCheckDate'];
    lastRemark = json['LastRemark'];
    trailerNumber = json['TrailerNumber'];
    lastCNTR = json['LastCNTR'];
    lastContactCode = json['LastContactCode'];
  }
}

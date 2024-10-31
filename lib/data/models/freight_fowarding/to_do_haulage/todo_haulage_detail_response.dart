class HaulageToDoDetail {
  String? actualEnd;
  String? actualStart;
  String? cntnNo;
  String? contactCode;
  String? contactName;
  String? equipmentType;
  String? pickUpPlaceName;
  String? planEnd;
  String? planStart;
  String? priEquipmentCode;
  String? refNo;
  String? sealNo;
  String? secEquipmentCode;
  String? taskMemo;
  String? wOTaskStatus;
  String? woEquipMode;
  String? woNo;
  int? woTaskId;
  String? tradeType;
  String? taskModeOrginal;
  String? driverMemo;
  String? woNoOrginal;
  String? dtdId;
  String? dtId;
  String? transportType;
  HaulageToDoDetail(
      {this.actualEnd,
      this.actualStart,
      this.cntnNo,
      this.contactCode,
      this.contactName,
      this.equipmentType,
      this.pickUpPlaceName,
      this.planEnd,
      this.planStart,
      this.priEquipmentCode,
      this.refNo,
      this.sealNo,
      this.secEquipmentCode,
      this.taskMemo,
      this.wOTaskStatus,
      this.woEquipMode,
      this.woNo,
      this.woTaskId,
      this.tradeType,
      this.taskModeOrginal,
      this.driverMemo,
      this.woNoOrginal,
      this.dtdId,
      this.dtId,
      this.transportType});

 

  factory HaulageToDoDetail.fromMap(Map<String, dynamic> map) {
    return HaulageToDoDetail(
      actualEnd: map['ActualEnd'],
      actualStart: map['ActualStart'],
      cntnNo: map['CNTRNo'],
      contactCode: map['ContactCode'],
      contactName: map['ContactName'],
      equipmentType: map['EquipmentType'],
      pickUpPlaceName: map['PickUpPlaceName'],
      planEnd: map['PlanEnd'],
      planStart: map['PlanStart'],
      priEquipmentCode: map['PriEquipmentCode'],
      refNo: map['RefNo'],
      sealNo: map['SealNo'],
      secEquipmentCode: map['SecEquipmentCode'],
      taskMemo: map['TaskMemo'],
      wOTaskStatus: map['WOTaskStatus'],
      woEquipMode: map['WOEquipMode'],
      woNo: map['WONo'],
      woTaskId: map['WOTaskId']?.toInt(),
      tradeType: map['TradeType'],
      taskModeOrginal: map['TaskModeOrginal'],
      driverMemo: map['DriverMemo'],
      woNoOrginal: map['WONoOrginal'],
      dtdId: map['DTDId'],
      dtId: map['DTId'],
      transportType: map['TransportType'],
    );
  }
}

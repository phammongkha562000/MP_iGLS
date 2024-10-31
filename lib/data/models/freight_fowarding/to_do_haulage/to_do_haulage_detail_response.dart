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
  HaulageToDoDetail({
    this.actualEnd,
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
  });

  HaulageToDoDetail copyWith({
    String? actualEnd,
    String? actualStart,
    String? cntnNo,
    String? contactCode,
    String? contactName,
    String? equipmentType,
    String? pickUpPlaceName,
    String? planEnd,
    String? planStart,
    String? priEquipmentCode,
    String? refNo,
    String? sealNo,
    String? secEquipmentCode,
    String? taskMemo,
    String? wOTaskStatus,
    String? woEquipMode,
    String? woNo,
    int? woTaskId,
    String? tradeType,
    String? taskModeOrginal,
    String? driverMemo,
    String? woNoOrginal,
    String? dtdId,
    String? dtId,
  }) {
    return HaulageToDoDetail(
      actualEnd: actualEnd ?? this.actualEnd,
      actualStart: actualStart ?? this.actualStart,
      cntnNo: cntnNo ?? this.cntnNo,
      contactCode: contactCode ?? this.contactCode,
      contactName: contactName ?? this.contactName,
      equipmentType: equipmentType ?? this.equipmentType,
      pickUpPlaceName: pickUpPlaceName ?? this.pickUpPlaceName,
      planEnd: planEnd ?? this.planEnd,
      planStart: planStart ?? this.planStart,
      priEquipmentCode: priEquipmentCode ?? this.priEquipmentCode,
      refNo: refNo ?? this.refNo,
      sealNo: sealNo ?? this.sealNo,
      secEquipmentCode: secEquipmentCode ?? this.secEquipmentCode,
      taskMemo: taskMemo ?? this.taskMemo,
      wOTaskStatus: wOTaskStatus ?? this.wOTaskStatus,
      woEquipMode: woEquipMode ?? this.woEquipMode,
      woNo: woNo ?? this.woNo,
      woTaskId: woTaskId ?? this.woTaskId,
      tradeType: tradeType ?? this.tradeType,
      taskModeOrginal: taskModeOrginal ?? this.taskModeOrginal,
      driverMemo: driverMemo ?? this.driverMemo,
      woNoOrginal: woNoOrginal ?? this.woNoOrginal,
      dtdId: dtdId ?? this.dtdId,
      dtId: dtId ?? this.dtId,
    );
  }

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
    );
  }
}

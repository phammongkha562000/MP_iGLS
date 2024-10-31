class ToDoHaulageResponse {
  ToDoHaulageResponse({
    this.actualEnd,
    this.actualStart,
    this.cntrNo,
    this.contactCode,
    this.contactName,
    this.dtdId,
    this.dtId,
    this.driverId,
    this.driverMemo,
    this.driverName,
    this.equipmentType,
    this.pickUpPlaceName,
    this.planEnd,
    this.planStart,
    this.priEquipmentCode,
    this.refNo,
    this.sealNo,
    this.secEquipmentCode,
    this.taskDate,
    this.taskMemo,
    this.taskModeOrginal,
    this.tradeType,
    this.woEquipMode,
    this.woNo,
    this.woNoOrginal,
    this.woTaskId,
    this.woTaskStatus,
  });

  String? actualEnd;
  String? actualStart;
  String? cntrNo;
  String? contactCode;
  dynamic contactName;
  dynamic dtdId;
  dynamic dtId;
  String? driverId;
  dynamic driverMemo;
  String? driverName;
  String? equipmentType;
  String? pickUpPlaceName;
  String? planEnd;
  String? planStart;
  String? priEquipmentCode;
  String? refNo;
  String? sealNo;
  String? secEquipmentCode;
  String? taskDate;
  String? taskMemo;
  String? taskModeOrginal;
  String? tradeType;
  String? woEquipMode;
  String? woNo;
  dynamic woNoOrginal;
  int? woTaskId;
  String? woTaskStatus;

  factory ToDoHaulageResponse.fromMap(Map<String, dynamic> json) =>
      ToDoHaulageResponse(
        actualEnd: json["ActualEnd"],
        actualStart: json["ActualStart"],
        cntrNo: json["CNTRNo"],
        contactCode: json["ContactCode"],
        contactName: json["ContactName"],
        dtdId: json["DTDId"],
        dtId: json["DTId"],
        driverId: json["DriverId"],
        driverMemo: json["DriverMemo"],
        driverName: json["DriverName"],
        equipmentType: json["EquipmentType"],
        pickUpPlaceName: json["PickUpPlaceName"],
        planEnd: json["PlanEnd"],
        planStart: json["PlanStart"],
        priEquipmentCode: json["PriEquipmentCode"],
        refNo: json["RefNo"],
        sealNo: json["SealNo"],
        secEquipmentCode: json["SecEquipmentCode"],
        taskDate: json["TaskDate"],
        taskMemo: json["TaskMemo"],
        taskModeOrginal: json["TaskModeOrginal"],
        tradeType: json["TradeType"],
        woEquipMode: json["WOEquipMode"],
        woNo: json["WONo"],
        woNoOrginal: json["WONoOrginal"],
        woTaskId: json["WOTaskId"],
        woTaskStatus: json["WOTaskStatus"],
      );
}

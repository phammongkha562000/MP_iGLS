// ignore_for_file: prefer_if_null_operators

class ShipmentStatusDetailResponse {
  ShipmentStatusDetailResponse({
    this.blNo,
    this.cntrNo,
    this.contactCode,
    this.date,
    this.equipTasks,
    this.orderEquipments,
  });

  String? blNo;
  String? cntrNo;
  String? contactCode;
  String? date;
  List<EquipTask>? equipTasks;
  List<OrderEquipment>? orderEquipments;

  factory ShipmentStatusDetailResponse.fromMap(Map<String, dynamic> json) =>
      ShipmentStatusDetailResponse(
        blNo: json["BLNo"],
        cntrNo: json["CNTRNo"],
        contactCode: json["ContactCode"],
        date: json["Date"],
        equipTasks: List<EquipTask>.from(
            json["equipTasks"].map((x) => EquipTask.fromMap(x))),
        orderEquipments: List<OrderEquipment>.from(
            json["orderEquipments"].map((x) => OrderEquipment.fromMap(x))),
      );
}

class EquipTask {
  EquipTask({
    this.actualEnd,
    this.actualStart,
    this.cyCode,
    this.cyName,
    this.itemNo,
    this.planEnd,
    this.planStart,
    this.priEquipmentCode,
    this.secEquipmentCode,
    this.taskMemo,
    this.taskModeOrginal,
    this.woEquipMode,
    this.woTaskId,
  });

  String? actualEnd;
  String? actualStart;
  String? cyCode;
  String? cyName;
  int? itemNo;
  String? planEnd;
  String? planStart;
  String? priEquipmentCode;
  String? secEquipmentCode;
  String? taskMemo;
  String? taskModeOrginal;
  String? woEquipMode;
  int? woTaskId;

  factory EquipTask.fromMap(Map<String, dynamic> json) => EquipTask(
        actualEnd: json["ActualEnd"],
        actualStart: json["ActualStart"],
        cyCode: json["CYCode"] == null ? null : json["CYCode"],
        cyName: json["CYName"] == null ? null : json["CYName"],
        itemNo: json["ItemNo"],
        planEnd: json["PlanEnd"],
        planStart: json["PlanStart"],
        priEquipmentCode: json["PriEquipmentCode"],
        secEquipmentCode: json["SecEquipmentCode"],
        taskMemo: json["TaskMemo"],
        taskModeOrginal: json["TaskModeOrginal"],
        woEquipMode: json["WOEquipMode"],
        woTaskId: json["WOTaskId"],
      );
}

class OrderEquipment {
  OrderEquipment({
    this.cntrPickUpAddId,
    this.cntrReturnAddId,
    this.deliveryAddress,
    this.deliveryPlaceId,
    this.equipmentNo,
    this.equipmentType,
    this.itemNo,
    this.loadUnloadEnd,
    this.loadUnloadStart,
    this.planLoadUnloadStart,
    this.refNo,
    this.sealNo,
    this.taskCount,
    this.woNo,
  });

  int? cntrPickUpAddId;
  int? cntrReturnAddId;
  String? deliveryAddress;
  int? deliveryPlaceId;
  String? equipmentNo;
  String? equipmentType;
  int? itemNo;
  String? loadUnloadEnd;
  String? loadUnloadStart;
  String? planLoadUnloadStart;
  String? refNo;
  String? sealNo;
  int? taskCount;
  String? woNo;

  factory OrderEquipment.fromMap(Map<String, dynamic> json) => OrderEquipment(
        cntrPickUpAddId: json["CNTRPickUpAddId"],
        cntrReturnAddId: json["CNTRReturnAddId"],
        deliveryAddress: json["DeliveryAddress"],
        deliveryPlaceId: json["DeliveryPlaceId"],
        equipmentNo: json["EquipmentNo"],
        equipmentType: json["EquipmentType"],
        itemNo: json["ItemNo"],
        loadUnloadEnd: json["LoadUnloadEnd"],
        loadUnloadStart: json["LoadUnloadStart"],
        planLoadUnloadStart: json["PlanLoadUnloadStart"] == null
            ? null
            : json["PlanLoadUnloadStart"],
        refNo: json["RefNo"],
        sealNo: json["SealNo"],
        taskCount: json["TaskCount"],
        woNo: json["WONo"],
      );
}

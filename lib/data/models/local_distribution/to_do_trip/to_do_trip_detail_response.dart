class ToDoTripDetailResponse {
  ToDoTripDetailResponse({
    this.codAmount,
    this.completeTime,
    this.ddcId,
    this.deliveryResult,
    this.driverDesc,
    this.driverId,
    this.etp,
    this.equipTypeNo,
    this.equipmentCode,
    this.equipmentDesc,
    this.failReason,
    this.failReasonDesc,
    this.ownership,
    this.pickUpArrival,
    this.securityCode,
    this.simpleOrderDetails,
    this.startTime,
    this.tripMemo,
    this.tripNo,
  });

  double? codAmount;
  String? completeTime;
  int? ddcId;
  String? deliveryResult;
  String? driverDesc;
  String? driverId;
  String? etp;
  String? equipTypeNo;
  String? equipmentCode;
  String? equipmentDesc;
  String? failReason;
  String? failReasonDesc;
  String? ownership;
  String? pickUpArrival;
  String? securityCode;
  List<SimpleOrderDetail>? simpleOrderDetails;
  String? startTime;
  String? tripMemo;
  String? tripNo;

  factory ToDoTripDetailResponse.fromMap(Map<String, dynamic> json) =>
      ToDoTripDetailResponse(
        completeTime: json["CompleteTime"],
        ddcId: json["DDCId"],
        deliveryResult: json["DeliveryResult"],
        driverDesc: json["DriverDesc"],
        driverId: json["DriverId"],
        etp: json["ETP"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        failReason: json["FailReason"],
        failReasonDesc: json["FailReasonDesc"],
        ownership: json["Ownership"],
        pickUpArrival: json["PickUpArrival"],
        securityCode: json["SecurityCode"],
        simpleOrderDetails: List<SimpleOrderDetail>.from(
            json["SimpleOrderDetails"]
                .map((x) => SimpleOrderDetail.fromMap(x))),
        startTime: json["StartTime"],
        tripMemo: json["TripMemo"],
        tripNo: json["TripNo"],
      );
}

class SimpleOrderDetail {
  SimpleOrderDetail(
      {this.arrivalTime,
      this.deliveryDate,
      this.deliveryResult,
      this.eta,
      this.etd,
      this.failReason,
      this.itemNote,
      this.orderCompletedDate,
      this.orderId,
      this.orderNo,
      this.pickAdd1,
      this.pickAddr2,
      this.pickAddr3,
      this.pickName,
      this.pickTel,
      this.pickUp,
      this.pickUpCode,
      this.pickupLat,
      this.pickupLon,
      this.priority,
      this.qty,
      this.routeItemNo,
      this.shipTo,
      this.seqNo,
      this.shipToAddress,
      this.shipToArea,
      this.shipToCode,
      this.shipToLat,
      this.shipToLon,
      this.shipToTel,
      this.tripType,
      this.otherRefNo1});

  String? arrivalTime;
  String? deliveryDate;
  String? deliveryResult;
  String? eta;
  String? etd;
  String? failReason;
  String? itemNote;
  String? orderCompletedDate;
  String? orderId;
  String? orderNo;
  String? pickAdd1;
  String? pickAddr2;
  String? pickAddr3;
  String? pickName;
  String? pickTel;
  String? pickUp;
  String? pickUpCode;
  double? pickupLat;
  double? pickupLon;
  String? priority;
  int? qty;
  String? routeItemNo;
  String? shipTo;
  int? seqNo;
  String? shipToAddress;
  String? shipToArea;
  String? shipToCode;
  double? shipToLat;
  double? shipToLon;
  String? shipToTel;
  String? tripType;
  String? otherRefNo1;

  factory SimpleOrderDetail.fromMap(Map<String, dynamic> json) =>
      SimpleOrderDetail(
        arrivalTime: json["ArrivalTime"],
        deliveryDate: json["DeliveryDate"],
        deliveryResult: json["DeliveryResult"],
        eta: json["ETA"],
        etd: json["ETD"],
        failReason: json["FailReason"],
        itemNote: json["ItemNote"],
        orderCompletedDate: json["OrderCompletedDate"],
        orderId: json["OrderId"],
        orderNo: json["OrderNo"],
        pickAdd1: json["PickAdd1"],
        pickAddr2: json["PickAddr2"],
        pickAddr3: json["PickAddr3"],
        pickName: json["PickName"],
        pickTel: json["PickTel"],
        pickUp: json["PickUp"],
        pickUpCode: json["PickUpCode"],
        pickupLat: json["PickupLat"].toDouble(),
        pickupLon: json["PickupLon"].toDouble(),
        priority: json["Priority"],
        qty: json["Qty"],
        routeItemNo: json["RouteItemNo"],
        shipTo: json["ShipTo"],
        seqNo: json["SeqNo"],
        shipToAddress: json["ShipToAddress"],
        shipToArea: json["ShipToArea"],
        shipToCode: json["ShipToCode"],
        shipToLat: json["ShipToLat"].toDouble(),
        shipToLon: json["ShipToLon"].toDouble(),
        shipToTel: json["ShipToTel"],
        tripType: json["TripType"],
        otherRefNo1: json["OtherRefNo1"],
      );
}

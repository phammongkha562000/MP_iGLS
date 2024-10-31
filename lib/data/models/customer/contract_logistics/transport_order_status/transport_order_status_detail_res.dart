class CustomerTOSDetailRes {
  List<GetTransportOrderDetailMovement>? getTransportOrderDetailMovement;
  List<GetTransportOrderDetailProcess>? getTransportOrderDetailProcess;
  List<GetTransportOrderGeneral>? getTransportOrderGeneral;

  CustomerTOSDetailRes({
    this.getTransportOrderDetailMovement,
    this.getTransportOrderDetailProcess,
    this.getTransportOrderGeneral,
  });

  factory CustomerTOSDetailRes.fromJson(Map<String, dynamic> json) =>
      CustomerTOSDetailRes(
        getTransportOrderDetailMovement:
            json["GetTransportOrderDetailMovement"] == null
                ? []
                : List<GetTransportOrderDetailMovement>.from(
                    json["GetTransportOrderDetailMovement"]!.map(
                        (x) => GetTransportOrderDetailMovement.fromJson(x))),
        getTransportOrderDetailProcess:
            json["GetTransportOrderDetailProcess"] == null
                ? []
                : List<GetTransportOrderDetailProcess>.from(
                    json["GetTransportOrderDetailProcess"]!.map(
                        (x) => GetTransportOrderDetailProcess.fromJson(x))),
        getTransportOrderGeneral: json["GetTransportOrderGeneral"] == null
            ? []
            : List<GetTransportOrderGeneral>.from(
                json["GetTransportOrderGeneral"]!
                    .map((x) => GetTransportOrderGeneral.fromJson(x))),
      );
}

class GetTransportOrderDetailMovement {
  String? actual;
  String? place;
  dynamic planned;
  String? processType;
  String? remark;
  String? updatedBy;

  GetTransportOrderDetailMovement({
    this.actual,
    this.place,
    this.planned,
    this.processType,
    this.remark,
    this.updatedBy,
  });

  factory GetTransportOrderDetailMovement.fromJson(Map<String, dynamic> json) =>
      GetTransportOrderDetailMovement(
        actual: json["Actual"],
        place: json["Place"],
        planned: json["Planned"],
        processType: json["ProcessType"],
        remark: json["Remark"],
        updatedBy: json["UpdatedBy"],
      );
}

class GetTransportOrderDetailProcess {
  String? completed;
  String? pickupArrival;
  String? planTime;
  String? startDelivery;

  GetTransportOrderDetailProcess({
    this.completed,
    this.pickupArrival,
    this.planTime,
    this.startDelivery,
  });

  factory GetTransportOrderDetailProcess.fromJson(Map<String, dynamic> json) =>
      GetTransportOrderDetailProcess(
        completed: json["COMPLETED"],
        pickupArrival: json["PICKUP_ARRIVAL"],
        planTime: json["PLAN_TIME"],
        startDelivery: json["START_DELIVERY"],
      );
}

class GetTransportOrderGeneral {
  double? codAmount;
  String? driverDesc;
  String? driverId;
  String? equipTypeNo;
  String? equipmentCode;
  String? equipmentDesc;
  String? gpsVendor;
  dynamic mobileNo;
  String? ordStatus;
  dynamic orderId;
  String? orderNo;
  String? pickUpAddress;
  String? pickUpName;
  String? shipToAddress;
  String? shipToName;
  double? totalQty;
  double? totalVolume;
  double? totalWeight;
  String? tripNo;
  String? tripStatusName;

  GetTransportOrderGeneral({
    this.codAmount,
    this.driverDesc,
    this.driverId,
    this.equipTypeNo,
    this.equipmentCode,
    this.equipmentDesc,
    this.gpsVendor,
    this.mobileNo,
    this.ordStatus,
    this.orderId,
    this.orderNo,
    this.pickUpAddress,
    this.pickUpName,
    this.shipToAddress,
    this.shipToName,
    this.totalQty,
    this.totalVolume,
    this.totalWeight,
    this.tripNo,
    this.tripStatusName,
  });

  factory GetTransportOrderGeneral.fromJson(Map<String, dynamic> json) =>
      GetTransportOrderGeneral(
        codAmount: json["CODAmount"],
        driverDesc: json["DriverDesc"],
        driverId: json["DriverID"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        gpsVendor: json["GPSVendor"],
        mobileNo: json["MobileNo"],
        ordStatus: json["OrdStatus"],
        orderId: json["OrderId"],
        orderNo: json["OrderNo"],
        pickUpAddress: json["PickUpAddress"],
        pickUpName: json["PickUpName"],
        shipToAddress: json["ShipToAddress"],
        shipToName: json["ShipToName"],
        totalQty: json["TotalQty"],
        totalVolume: json["TotalVolume"]?.toDouble(),
        totalWeight: json["TotalWeight"],
        tripNo: json["TripNo"],
        tripStatusName: json["TripStatusName"],
      );
}

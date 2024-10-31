class NormalTripDetailResponse {
  NormalTripDetailResponse({
    this.ddcId,
    this.driverDescription,
    this.driverId,
    this.equipmemtCode,
    this.equipmentDescription,
    this.equipmentType,
    this.equipmentTypeDesc,
    this.eta,
    this.etp,
    this.height,
    this.lenght,
    this.markerStepInfos,
    this.orderNormal,
    this.quantity,
    this.tripNo,
    this.tripPlanOrders,
    this.tripStatus,
    this.tripStatusDesc,
    this.tripType,
    this.tripTypeDesc,
    this.width,
  });

  int? ddcId;
  String? driverDescription;
  String? driverId;
  String? equipmemtCode;
  String? equipmentDescription;
  String? equipmentType;
  String? equipmentTypeDesc;
  String? eta;
  String? etp;
  dynamic height;
  dynamic lenght;
  List<MarkerStepInfo>? markerStepInfos;
  List<OrderNormal>? orderNormal;
  dynamic quantity;
  String? tripNo;
  List<TripPlanOrder>? tripPlanOrders;
  String? tripStatus;
  String? tripStatusDesc;
  String? tripType;
  String? tripTypeDesc;
  dynamic width;

  factory NormalTripDetailResponse.fromMap(Map<String, dynamic> json) =>
      NormalTripDetailResponse(
        ddcId: json["DDCId"],
        driverDescription: json["DriverDescription"],
        driverId: json["DriverId"],
        equipmemtCode: json["EquipmemtCode"],
        equipmentDescription: json["EquipmentDescription"],
        equipmentType: json["EquipmentType"],
        equipmentTypeDesc: json["EquipmentTypeDesc"],
        eta: json["Eta"],
        etp: json["Etp"],
        height: json["Height"],
        lenght: json["Lenght"],
        markerStepInfos: List<MarkerStepInfo>.from(
            json["MarkerStepInfos"].map((x) => MarkerStepInfo.fromMap(x))),
        orderNormal: List<OrderNormal>.from(
            json["Orders"].map((x) => OrderNormal.fromMap(x))),
        quantity: json["Quantity"],
        tripNo: json["TripNo"],
        tripPlanOrders: List<TripPlanOrder>.from(
            json["TripPlanOrders"].map((x) => TripPlanOrder.fromMap(x))),
        tripStatus: json["TripStatus"],
        tripStatusDesc: json["TripStatusDesc"],
        tripType: json["TripType"],
        tripTypeDesc: json["TripTypeDesc"],
        width: json["Width"],
      );
}

class MarkerStepInfo {
  MarkerStepInfo({
    this.eventDate,
    this.eventType,
    this.itemNo,
    this.lat,
    this.lon,
    this.placeDesc,
  });

  String? eventDate;
  String? eventType;
  int? itemNo;
  String? lat;
  String? lon;
  String? placeDesc;

  factory MarkerStepInfo.fromMap(Map<String, dynamic> json) => MarkerStepInfo(
        eventDate: json["EventDate"],
        eventType: json["EventType"],
        itemNo: json["ItemNo"],
        lat: json["Lat"],
        lon: json["Lon"],
        placeDesc: json["PlaceDesc"],
      );
}

class OrderNormal {
  OrderNormal({
    this.clientRefNo,
    this.orderId,
  });

  String? clientRefNo;
  String? orderId;

  factory OrderNormal.fromMap(Map<String?, dynamic> json) => OrderNormal(
        clientRefNo: json["ClientRefNo"],
        orderId: json["OrderId"],
      );
}

class TripPlanOrder {
  TripPlanOrder({
    this.clientRefNo,
    this.driverDescription,
    this.driverId,
    this.equipmentCode,
    this.equipmentDescription,
    this.equipmentType,
    this.orderId,
    this.orgAddr1,
    this.orgAddr2,
    this.orgName,
    this.quantity,
    this.routeType,
    this.seqNo,
    this.volume,
  });
  String? clientRefNo;
  dynamic driverDescription;
  dynamic driverId;
  dynamic equipmentCode;
  dynamic equipmentDescription;
  dynamic equipmentType;
  dynamic orderId;
  String? orgAddr1;
  String? orgAddr2;
  String? orgName;
  dynamic quantity;
  String? routeType;
  int? seqNo;
  int? volume;

  factory TripPlanOrder.fromMap(Map<String, dynamic> json) => TripPlanOrder(
        clientRefNo: json["ClientRefNo"],
        driverDescription: json["DriverDescription"],
        driverId: json["DriverId"],
        equipmentCode: json["EquipmentCode"],
        equipmentDescription: json["EquipmentDescription"],
        equipmentType: json["EquipmentType"],
        orderId: json["OrderId"],
        orgAddr1: json["OrgAddr1"],
        orgAddr2: json["OrgAddr2"],
        orgName: json["OrgName"],
        quantity: json["Quantity"],
        routeType: json["RouteType"],
        seqNo: json["SeqNo"],
        volume: json["Volume"],
      );
}

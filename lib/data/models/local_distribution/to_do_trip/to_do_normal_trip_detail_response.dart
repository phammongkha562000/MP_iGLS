class ToDoNormalTripDetailResponse {
  ToDoNormalTripDetailResponse({
    this.orgTrip,
    this.tripEvents,
  });

  List<OrgTrip>? orgTrip;
  List<TripEvent>? tripEvents;

  factory ToDoNormalTripDetailResponse.fromJson(Map<String, dynamic> json) =>
      ToDoNormalTripDetailResponse(
        orgTrip:
            List<OrgTrip>.from(json["OrgTrip"].map((x) => OrgTrip.fromJson(x))),
        tripEvents: List<TripEvent>.from(
            json["TripEvents"].map((x) => TripEvent.fromJson(x))),
      );
}

class OrgTrip {
  OrgTrip(
      {this.eta,
      this.etp,
      this.etd,
      this.eventDate,
      this.eventDateVal,
      this.eventType,
      this.ordeId,
      this.orderNo,
      this.orgPicCode,
      this.orgPicName,
      this.orgShpCode,
      this.orgShpName,
      this.picLat,
      this.picLon,
      this.picTel,
      this.picToAddr,
      this.routeItemNo,
      this.shpLat,
      this.shpLon,
      this.shpTel,
      this.seqNo,
      this.shipToAddr,
      this.clientRefNo});

  String? eta;
  String? etp;
  String? etd;
  String? eventDate;
  String? eventDateVal;
  String? eventType;
  int? ordeId;
  String? orderNo;
  String? orgPicCode;
  String? orgPicName;
  String? orgShpCode;
  String? orgShpName;
  String? picLat;
  String? picLon;
  String? picTel;
  String? picToAddr;
  String? routeItemNo;
  String? shpLat;
  String? shpLon;
  String? shpTel;
  String? seqNo;
  String? shipToAddr;
  String? clientRefNo;

  factory OrgTrip.fromJson(Map<String, dynamic> json) => OrgTrip(
        eta: json["ETA"],
        etp: json["ETP"],
        etd: json["ETD"],
        eventDate: json["EventDate"],
        eventDateVal: json["EventDateVal"],
        eventType: json["EventType"],
        ordeId: json["OrdeId"],
        orderNo: json["OrderNo"],
        orgPicCode: json["OrgPICCode"],
        orgPicName: json["OrgPICName"],
        orgShpCode: json["OrgSHPCode"],
        orgShpName: json["OrgSHPName"],
        picLat: json["PICLat"],
        picLon: json["PICLon"],
        picTel: json["PICTel"],
        picToAddr: json["PicToAddr"],
        routeItemNo: json["RouteItemNo"],
        shpLat: json["SHPLat"],
        shpLon: json["SHPLon"],
        shpTel: json["SHPTel"],
        seqNo: json["SeqNo"],
        shipToAddr: json["ShipToAddr"],
        clientRefNo: json["ClientRefNo"],
      );
}

class TripEvent {
  TripEvent({
    this.eventDate,
    this.eventDateVal,
    this.eventType,
    this.eventTypeDesc,
  });

  String? eventDate;
  String? eventDateVal;
  String? eventType;
  String? eventTypeDesc;

  factory TripEvent.fromJson(Map<String, dynamic> json) => TripEvent(
        eventDate: json["EventDate"],
        eventDateVal: json["EventDateVal"],
        eventType: json["EventType"],
        eventTypeDesc: json["EventTypeDesc"],
      );
}

class ShuttleTripsResponse {
  ShuttleTripsResponse(
      {this.contactCode,
      this.createDate,
      this.createUser,
      this.dcCode,
      this.endLoc,
      this.endLocDesc,
      this.endTime,
      this.invoiceNo,
      this.isPosted,
      this.itemNote,
      this.postUser,
      this.postedDate,
      this.postedStatus,
      this.qty,
      this.stId,
      this.shipmentNo,
      this.startLoc,
      this.startLocDesc,
      this.startTime,
      this.tripMode,
      this.tripNo,
      this.updateDate,
      this.updateUser,
      this.eLat,
      this.eLon,
      this.sLat,
      this.sLon});

  String? contactCode;
  String? createDate;
  String? createUser;
  String? dcCode;
  String? endLoc;
  String? endLocDesc;
  String? endTime;
  String? invoiceNo;
  String? isPosted;
  String? itemNote;
  dynamic postUser;
  dynamic postedDate;
  String? postedStatus;
  double? qty;
  int? stId;
  String? shipmentNo;
  String? startLoc;
  String? startLocDesc;
  String? startTime;
  String? tripMode;
  dynamic tripNo;
  String? updateDate;
  String? updateUser;
  String? sLat;
  String? sLon;
  String? eLat;
  String? eLon;

  factory ShuttleTripsResponse.fromJson(Map<String, dynamic> json) =>
      ShuttleTripsResponse(
        contactCode: json["ContactCode"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        endLoc: json["EndLoc"],
        endLocDesc: json["EndLocDesc"],
        endTime: json["EndTime"],
        invoiceNo: json["InvoiceNo"],
        isPosted: json["IsPosted"],
        itemNote: json["ItemNote"],
        postUser: json["PostUser"],
        postedDate: json["PostedDate"],
        postedStatus: json["PostedStatus"],
        qty: json["Qty"],
        stId: json["STId"],
        shipmentNo: json["ShipmentNo"],
        startLoc: json["StartLoc"],
        startLocDesc: json["StartLocDesc"],
        startTime: json["StartTime"],
        tripMode: json["TripMode"],
        tripNo: json["TripNo"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        eLon: json["ELon"],
        eLat: json["ELat"],
        sLon: json["SLon"],
        sLat: json["SLat"],
      );
}

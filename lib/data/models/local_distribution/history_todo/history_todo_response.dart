class HistoryTodoResponse {
  HistoryTodoResponse({this.totalCount, this.totalPage, this.results});

  List<HistoryTrip>? results;
  int? totalCount;
  int? totalPage;

  factory HistoryTodoResponse.fromMap(Map<String, dynamic> json) =>
      HistoryTodoResponse(
        results: json["Results"] == null
            ? []
            : List<HistoryTrip>.from(
                json["Results"].map((x) => HistoryTrip.fromMap(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );
}

class HistoryTrip {
  HistoryTrip(
      {this.contactCode,
      this.dDCId,
      this.driverTripType,
      this.driverTripTypeDesc,
      this.eta,
      this.etp,
      this.picAddress,
      this.picCode,
      this.picName,
      this.shipToAddress,
      this.shipToCode,
      this.shipToName,
      this.totalOrder,
      this.tripNo,
      this.tripStatus,
      this.tripType});
  int? dDCId;
  String? contactCode;
  String? driverTripType;
  String? driverTripTypeDesc;
  String? eta;
  String? etp;
  String? picAddress;
  String? picCode;
  String? picName;
  String? shipToAddress;
  String? shipToCode;
  String? shipToName;
  int? totalOrder;
  String? tripNo;
  String? tripStatus;
  String? tripType;

  factory HistoryTrip.fromMap(Map<String, dynamic> json) => HistoryTrip(
        contactCode: json["ContactCode"],
        dDCId: json["DDCId"],
        driverTripType: json["DriverTripType"],
        driverTripTypeDesc: json["DriverTripTypeDesc"],
        eta: json["ETA"],
        etp: json["ETP"],
        picAddress: json["PicAddress"],
        picCode: json["PicCode"],
        picName: json["PicName"],
        shipToAddress: json["ShipToAddress"],
        shipToCode: json["ShipToCode"],
        shipToName: json["ShipToName"],
        totalOrder: json["TotalOrder"],
        tripNo: json["TripNo"],
        tripStatus: json["TripStatus"],
        tripType: json["TripType"],
      );
}

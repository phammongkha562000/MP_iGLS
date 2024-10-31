class CustomerShuttleOverviewRes {
  List<GetShuttleOverView1>? getShuttleOverView1;
  List<GetShuttleOverView2>? getShuttleOverView2;
  List<GetShuttleOverView3>? getShuttleOverView3;

  CustomerShuttleOverviewRes({
    this.getShuttleOverView1,
    this.getShuttleOverView2,
    this.getShuttleOverView3,
  });

  factory CustomerShuttleOverviewRes.fromJson(Map<String, dynamic> json) =>
      CustomerShuttleOverviewRes(
        getShuttleOverView1: json["getShuttleOverView1"] == null
            ? []
            : List<GetShuttleOverView1>.from(json["getShuttleOverView1"]!
                .map((x) => GetShuttleOverView1.fromJson(x))),
        getShuttleOverView2: json["getShuttleOverView2"] == null
            ? []
            : List<GetShuttleOverView2>.from(json["getShuttleOverView2"]!
                .map((x) => GetShuttleOverView2.fromJson(x))),
        getShuttleOverView3: json["getShuttleOverView3"] == null
            ? []
            : List<GetShuttleOverView3>.from(json["getShuttleOverView3"]!
                .map((x) => GetShuttleOverView3.fromJson(x))),
      );
}

class GetShuttleOverView1 {
  String? contactCode;
  String? createUser;
  String? dcCode;
  dynamic eLat;
  dynamic eLon;
  dynamic endTime;
  String? equipmentCode;
  String? invoiceNo;
  int? itemNo;
  String? itemNote;
  double? qty;
  String? sLat;
  String? sLon;
  int? stId;
  String? shipmentNo;
  dynamic staffName;
  String? startTime;
  String? tripMode;
  dynamic tripNo;

  GetShuttleOverView1({
    this.contactCode,
    this.createUser,
    this.dcCode,
    this.eLat,
    this.eLon,
    this.endTime,
    this.equipmentCode,
    this.invoiceNo,
    this.itemNo,
    this.itemNote,
    this.qty,
    this.sLat,
    this.sLon,
    this.stId,
    this.shipmentNo,
    this.staffName,
    this.startTime,
    this.tripMode,
    this.tripNo,
  });

  factory GetShuttleOverView1.fromJson(Map<String, dynamic> json) =>
      GetShuttleOverView1(
        contactCode: json["ContactCode"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        eLat: json["ELat"],
        eLon: json["ELon"],
        endTime: json["EndTime"],
        equipmentCode: json["EquipmentCode"],
        invoiceNo: json["InvoiceNo"],
        itemNo: json["ItemNo"],
        itemNote: json["ItemNote"],
        qty: json["Qty"].toDouble(),
        sLat: json["SLat"],
        sLon: json["SLon"],
        stId: json["STId"],
        shipmentNo: json["ShipmentNo"],
        staffName: json["StaffName"],
        startTime: json["StartTime"],
        tripMode: json["TripMode"],
        tripNo: json["TripNo"],
      );
}

class GetShuttleOverView2 {
  int? avgTripMinute;
  String? createUser;
  String? equipmentCode;
  String? firstTime;
  dynamic latestTime;
  dynamic staffName;
  int? trips;

  GetShuttleOverView2({
    this.avgTripMinute,
    this.createUser,
    this.equipmentCode,
    this.firstTime,
    this.latestTime,
    this.staffName,
    this.trips,
  });

  factory GetShuttleOverView2.fromJson(Map<String, dynamic> json) =>
      GetShuttleOverView2(
        avgTripMinute: json["AvgTripMinute"],
        createUser: json["CreateUser"],
        equipmentCode: json["EquipmentCode"],
        firstTime: json["FirstTime"],
        latestTime: json["LatestTime"],
        staffName: json["StaffName"],
        trips: json["Trips"],
      );
}

class GetShuttleOverView3 {
  int? avgMinute;
  double? avgTripHour;
  double? avgTrips;
  String? dates;
  int? trips;
  int? trucks;

  GetShuttleOverView3({
    this.avgMinute,
    this.avgTripHour,
    this.avgTrips,
    this.dates,
    this.trips,
    this.trucks,
  });

  factory GetShuttleOverView3.fromJson(Map<String, dynamic> json) =>
      GetShuttleOverView3(
        avgMinute: json["AvgMinute"],
        avgTripHour: json["AvgTripHour"].toDouble(),
        avgTrips: json["AvgTrips"].toDouble(),
        dates: json["Dates"],
        trips: json["Trips"],
        trucks: json["Trucks"],
      );
}

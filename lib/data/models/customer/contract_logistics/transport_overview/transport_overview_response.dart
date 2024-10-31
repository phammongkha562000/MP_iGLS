class CustomerTransportOverviewRes {
  List<TransportOverStatisReport>? transportOverStatisReport;
  List<TransportOverStatisReportDetail>? transportOverStatisReportDetail;

  CustomerTransportOverviewRes({
    this.transportOverStatisReport,
    this.transportOverStatisReportDetail,
  });

  factory CustomerTransportOverviewRes.fromJson(Map<String, dynamic> json) =>
      CustomerTransportOverviewRes(
        transportOverStatisReport: json["TransportOverStatisReport"] == null
            ? []
            : List<TransportOverStatisReport>.from(
                json["TransportOverStatisReport"]!
                    .map((x) => TransportOverStatisReport.fromJson(x))),
        transportOverStatisReportDetail:
            json["TransportOverStatisReportDetail"] == null
                ? []
                : List<TransportOverStatisReportDetail>.from(
                    json["TransportOverStatisReportDetail"]!.map(
                        (x) => TransportOverStatisReportDetail.fromJson(x))),
      );
}

class TransportOverStatisReport {
  String? mmdd;
  int? orders;
  int? trips;
  double? volume;
  double? weight;

  TransportOverStatisReport({
    this.mmdd,
    this.orders,
    this.trips,
    this.volume,
    this.weight,
  });

  factory TransportOverStatisReport.fromJson(Map<String, dynamic> json) =>
      TransportOverStatisReport(
        mmdd: json["MMDD"],
        orders: json["Orders"],
        trips: json["Trips"],
        volume: json["Volume"].toDouble(),
        weight: json["Weight"].toDouble(),
      );
}

class TransportOverStatisReportDetail {
  double? codAmount;
  dynamic completed;
  String? driverDesc;
  dynamic gpsVendor;
  String? orderNoLists;
  int? orders;
  dynamic pickUpArrival;
  String? shipToes;
  dynamic startDelivery;
  String? tripNo;
  String? tripStatus;
  String? truckNo;

  TransportOverStatisReportDetail({
    this.codAmount,
    this.completed,
    this.driverDesc,
    this.gpsVendor,
    this.orderNoLists,
    this.orders,
    this.pickUpArrival,
    this.shipToes,
    this.startDelivery,
    this.tripNo,
    this.tripStatus,
    this.truckNo,
  });

  factory TransportOverStatisReportDetail.fromJson(Map<String, dynamic> json) =>
      TransportOverStatisReportDetail(
        codAmount: json["CODAmount"].toDouble(),
        completed: json["Completed"],
        driverDesc: json["DriverDesc"],
        gpsVendor: json["GPSVendor"],
        orderNoLists: json["OrderNoLists"],
        orders: json["Orders"],
        pickUpArrival: json["PickUpArrival"],
        shipToes: json["ShipToes"],
        startDelivery: json["StartDelivery"],
        tripNo: json["TripNo"],
        tripStatus: json["TripStatus"],
        truckNo: json["TruckNo"],
      );
}

class CustomerHaulageOverviewRes {
  List<HaulageOverViewImport>? haulageOverViewImports;
  List<HaulageOverViewPickup>? haulageOverViewPickups;
  List<HaulageOverViewSummaryArrival>? haulageOverViewSummaryArrivals;
  List<HaulageOverViewSummaryLoading>? haulageOverViewSummaryLoadings;
  List<TransportOverStatisReportDetails>? transportOverStatisReportDetails;

  CustomerHaulageOverviewRes({
    this.haulageOverViewImports,
    this.haulageOverViewPickups,
    this.haulageOverViewSummaryArrivals,
    this.haulageOverViewSummaryLoadings,
    this.transportOverStatisReportDetails,
  });

  factory CustomerHaulageOverviewRes.fromJson(Map<String, dynamic> json) =>
      CustomerHaulageOverviewRes(
        haulageOverViewImports: json["HaulageOverViewImports"] == null
            ? []
            : List<HaulageOverViewImport>.from(json["HaulageOverViewImports"]!
                .map((x) => HaulageOverViewImport.fromJson(x))),
        haulageOverViewPickups: json["HaulageOverViewPickups"] == null
            ? []
            : List<HaulageOverViewPickup>.from(json["HaulageOverViewPickups"]!
                .map((x) => HaulageOverViewPickup.fromJson(x))),
        haulageOverViewSummaryArrivals:
            json["HaulageOverViewSummaryArrivals"] == null
                ? []
                : List<HaulageOverViewSummaryArrival>.from(
                    json["HaulageOverViewSummaryArrivals"]!
                        .map((x) => HaulageOverViewSummaryArrival.fromJson(x))),
        haulageOverViewSummaryLoadings:
            json["HaulageOverViewSummaryLoadings"] == null
                ? []
                : List<HaulageOverViewSummaryLoading>.from(
                    json["HaulageOverViewSummaryLoadings"]!
                        .map((x) => HaulageOverViewSummaryLoading.fromJson(x))),
        transportOverStatisReportDetails:
            json["TransportOverStatisReportDetails"] == null
                ? []
                : List<TransportOverStatisReportDetails>.from(
                    json["TransportOverStatisReportDetails"]!.map(
                        (x) => TransportOverStatisReportDetails.fromJson(x))),
      );
}

class HaulageOverViewPickup {
  String? cntrNo;
  String? cntrType;
  String? carrier;
  String? carrierBcNo;
  String? containerStatus;
  String? driverName;
  String? etd;
  String? gpsVendor;
  dynamic pnk;
  dynamic podCountryName;
  dynamic podName;
  String? pickUpArrival;
  String? pickUpTractor;
  dynamic pickupTrailer;
  String? taskMemo;
  int? woItemNo;
  String? woNo;

  HaulageOverViewPickup({
    this.cntrNo,
    this.cntrType,
    this.carrier,
    this.carrierBcNo,
    this.containerStatus,
    this.driverName,
    this.etd,
    this.gpsVendor,
    this.pnk,
    this.podCountryName,
    this.podName,
    this.pickUpArrival,
    this.pickUpTractor,
    this.pickupTrailer,
    this.taskMemo,
    this.woItemNo,
    this.woNo,
  });

  factory HaulageOverViewPickup.fromJson(Map<String, dynamic> json) =>
      HaulageOverViewPickup(
        cntrNo: json["CNTRNo"],
        cntrType: json["CNTRType"],
        carrier: json["Carrier"],
        carrierBcNo: json["CarrierBCNo"],
        containerStatus: json["ContainerStatus"],
        driverName: json["DriverName"],
        etd: json["ETD"],
        gpsVendor: json["GPSVendor"],
        pnk: json["PNK"],
        podCountryName: json["PODCountryName"],
        podName: json["PODName"],
        pickUpArrival: json["PickUpArrival"],
        pickUpTractor: json["PickUpTractor"],
        pickupTrailer: json["PickupTrailer"],
        taskMemo: json["TaskMemo"],
        woItemNo: json["WOItemNo"],
        woNo: json["WONo"],
      );
}

class HaulageOverViewSummaryArrival {
  int? arrival;
  double? percents;
  int? planed;

  HaulageOverViewSummaryArrival({
    this.arrival,
    this.percents,
    this.planed,
  });

  factory HaulageOverViewSummaryArrival.fromJson(Map<String, dynamic> json) =>
      HaulageOverViewSummaryArrival(
        arrival: json["Arrival"],
        percents: json["Percents"].toDouble(),
        planed: json["Planed"],
      );
}

class HaulageOverViewSummaryLoading {
  int? loadEnd;
  double? percents;
  int? planed;

  HaulageOverViewSummaryLoading({
    this.loadEnd,
    this.percents,
    this.planed,
  });

  factory HaulageOverViewSummaryLoading.fromJson(Map<String, dynamic> json) =>
      HaulageOverViewSummaryLoading(
        loadEnd: json["LoadEnd"],
        percents: json["Percents"].toDouble(),
        planed: json["Planed"],
      );
}

class HaulageOverViewImport {
  int? atPort;
  String? blNo;
  String? cntrNo;
  String? cntrType;
  String? cargoMode;
  dynamic comodity;
  String? contactCode;
  String? demdetDue;
  String? demdue;
  dynamic detDue;
  dynamic detFreeDays;
  int? dayAging1Det;
  int? dayAging2Demdet;
  int? dayAging3Dem;
  dynamic deliveryRtn;
  String? eta;
  dynamic gpsVendor;
  String? importCd;
  String? origin;
  dynamic pickUp;
  int? pickUpStaging;
  dynamic pickUpTractor;
  dynamic premitDone;
  dynamic stageCy;
  dynamic stageTractor;
  int? staging;
  dynamic stagingCy;
  int? woItemNo;
  String? woNo;

  HaulageOverViewImport({
    this.atPort,
    this.blNo,
    this.cntrNo,
    this.cntrType,
    this.cargoMode,
    this.comodity,
    this.contactCode,
    this.demdetDue,
    this.demdue,
    this.detDue,
    this.detFreeDays,
    this.dayAging1Det,
    this.dayAging2Demdet,
    this.dayAging3Dem,
    this.deliveryRtn,
    this.eta,
    this.gpsVendor,
    this.importCd,
    this.origin,
    this.pickUp,
    this.pickUpStaging,
    this.pickUpTractor,
    this.premitDone,
    this.stageCy,
    this.stageTractor,
    this.staging,
    this.stagingCy,
    this.woItemNo,
    this.woNo,
  });

  factory HaulageOverViewImport.fromJson(Map<String, dynamic> json) =>
      HaulageOverViewImport(
        atPort: json["AtPort"],
        blNo: json["BLNo"],
        cntrNo: json["CNTRNo"],
        cntrType: json["CNTRType"],
        cargoMode: json["CargoMode"],
        comodity: json["Comodity"],
        contactCode: json["ContactCode"],
        demdetDue: json["DEMDETDue"],
        demdue: json["DEMDUE"],
        detDue: json["DETDue"],
        detFreeDays: json["DETFreeDays"],
        dayAging1Det: json["DayAging1_DET"],
        dayAging2Demdet: json["DayAging2_DEMDET"],
        dayAging3Dem: json["DayAging3_DEM"],
        deliveryRtn: json["DeliveryRtn"],
        eta: json["ETA"],
        gpsVendor: json["GPSVendor"],
        importCd: json["ImportCD"],
        origin: json["Origin"],
        pickUp: json["PickUp"],
        pickUpStaging: json["PickUpStaging"],
        pickUpTractor: json["PickUpTractor"],
        premitDone: json["PremitDone"],
        stageCy: json["StageCY"],
        stageTractor: json["StageTractor"],
        staging: json["Staging"],
        stagingCy: json["StagingCY"],
        woItemNo: json["WOItemNo"],
        woNo: json["WONo"],
      );
}

class TransportOverStatisReportDetails {
  String? cntrNo;
  String? cntrType;
  String? carrier;
  String? carrierBcNo;
  String? containerStatus;
  String? finalDestination;
  String? loadEnd;
  String? loadStart;
  dynamic pnk;
  dynamic podCountryName;
  dynamic podName;
  int? woItemNo;
  String? woNo;

  TransportOverStatisReportDetails({
    this.cntrNo,
    this.cntrType,
    this.carrier,
    this.carrierBcNo,
    this.containerStatus,
    this.finalDestination,
    this.loadEnd,
    this.loadStart,
    this.pnk,
    this.podCountryName,
    this.podName,
    this.woItemNo,
    this.woNo,
  });

  factory TransportOverStatisReportDetails.fromJson(
          Map<String, dynamic> json) =>
      TransportOverStatisReportDetails(
        cntrNo: json["CNTRNo"],
        cntrType: json["CNTRType"],
        carrier: json["Carrier"],
        carrierBcNo: json["CarrierBCNo"],
        containerStatus: json["ContainerStatus"],
        finalDestination: json["FinalDestination"],
        loadEnd: json["LoadEnd"],
        loadStart: json["LoadStart"],
        pnk: json["PNK"],
        podCountryName: json["PODCountryName"],
        podName: json["PODName"],
        woItemNo: json["WOItemNo"],
        woNo: json["WONo"],
      );
}

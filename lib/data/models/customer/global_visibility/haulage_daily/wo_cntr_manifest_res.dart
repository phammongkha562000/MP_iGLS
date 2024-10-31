class CustomerHaualgeWocntrRes {
  GetWocntrManifestsResult? getWocntrManifestsResult;

  CustomerHaualgeWocntrRes({
    this.getWocntrManifestsResult,
  });

  factory CustomerHaualgeWocntrRes.fromJson(Map<String, dynamic> json) =>
      CustomerHaualgeWocntrRes(
        getWocntrManifestsResult: json["GetWOCNTRManifestsResult"] == null
            ? null
            : GetWocntrManifestsResult.fromJson(
                json["GetWOCNTRManifestsResult"]),
      );
}

class GetWocntrManifestsResult {
  dynamic lstWocntrManifests;
  List<WocDetail>? wocDetail;

  GetWocntrManifestsResult({
    this.lstWocntrManifests,
    this.wocDetail,
  });

  factory GetWocntrManifestsResult.fromJson(Map<String, dynamic> json) =>
      GetWocntrManifestsResult(
        lstWocntrManifests: json["LstWOCNTRManifests"],
        wocDetail: json["WOCDetail"] == null
            ? []
            : List<WocDetail>.from(
                json["WOCDetail"]!.map((x) => WocDetail.fromJson(x))),
      );
}

class WocDetail {
  dynamic actualEnd;
  dynamic actualStart;
  String? blNo;
  dynamic cdDate;
  dynamic cdNo;
  String? custRefNo;
  dynamic driverDesc;
  dynamic driverMobile;
  dynamic equipmentDesc;
  String? pod;
  String? pol;
  dynamic pickDate;
  dynamic pickVendor;
  String? taskMemo;
  String? taskStatus;
  dynamic tractor;
  String? tradeType;
  dynamic trailer;
  String? vesselorFlight;
  String? woEquipMode;
  String? woNo;
  int? woTaskId;

  WocDetail({
    this.actualEnd,
    this.actualStart,
    this.blNo,
    this.cdDate,
    this.cdNo,
    this.custRefNo,
    this.driverDesc,
    this.driverMobile,
    this.equipmentDesc,
    this.pod,
    this.pol,
    this.pickDate,
    this.pickVendor,
    this.taskMemo,
    this.taskStatus,
    this.tractor,
    this.tradeType,
    this.trailer,
    this.vesselorFlight,
    this.woEquipMode,
    this.woNo,
    this.woTaskId,
  });

  factory WocDetail.fromJson(Map<String, dynamic> json) => WocDetail(
        actualEnd: json["ActualEnd"],
        actualStart: json["ActualStart"],
        blNo: json["BLNo"],
        cdDate: json["CDDate"],
        cdNo: json["CDNo"],
        custRefNo: json["CustRefNo"],
        driverDesc: json["DriverDesc"],
        driverMobile: json["DriverMobile"],
        equipmentDesc: json["EquipmentDesc"],
        pod: json["POD"],
        pol: json["POL"],
        pickDate: json["PickDate"],
        pickVendor: json["PickVendor"],
        taskMemo: json["TaskMemo"],
        taskStatus: json["TaskStatus"],
        tractor: json["Tractor"],
        tradeType: json["TradeType"],
        trailer: json["Trailer"],
        vesselorFlight: json["VesselorFlight"],
        woEquipMode: json["WOEquipMode"],
        woNo: json["WONo"],
        woTaskId: json["WOTaskId"],
      );
}

class GetDetailCntrHaulageRes {
  GetWOCNTRManifestsResult? getWOCNTRManifestsResult;

  GetDetailCntrHaulageRes({this.getWOCNTRManifestsResult});

  GetDetailCntrHaulageRes.fromJson(Map<String, dynamic> json) {
    getWOCNTRManifestsResult = json['GetWOCNTRManifestsResult'] != null
        ? GetWOCNTRManifestsResult.fromJson(json['GetWOCNTRManifestsResult'])
        : null;
  }
}

class GetWOCNTRManifestsResult {
  dynamic lstWOCNTRManifests;
  List<WOCDetail>? wOCDetail;

  GetWOCNTRManifestsResult({this.lstWOCNTRManifests, this.wOCDetail});

  GetWOCNTRManifestsResult.fromJson(Map<String, dynamic> json) {
    lstWOCNTRManifests = json['LstWOCNTRManifests'];
    if (json['WOCDetail'] != null) {
      wOCDetail = <WOCDetail>[];
      json['WOCDetail'].forEach((v) {
        wOCDetail!.add(WOCDetail.fromJson(v));
      });
    }
  }
}

class WOCDetail {
  String? actualEnd;
  String? actualStart;
  String? bLNo;
  dynamic cDDate;
  dynamic cDNo;
  String? custRefNo;
  String? driverDesc;
  String? driverMobile;
  String? equipmentDesc;
  String? pOD;
  String? pOL;
  String? pickDate;
  String? pickVendor;
  String? taskMemo;
  String? taskStatus;
  String? tractor;
  String? tradeType;
  String? trailer;
  String? vesselorFlight;
  String? wOEquipMode;
  String? wONo;
  int? wOTaskId;

  WOCDetail(
      {this.actualEnd,
      this.actualStart,
      this.bLNo,
      this.cDDate,
      this.cDNo,
      this.custRefNo,
      this.driverDesc,
      this.driverMobile,
      this.equipmentDesc,
      this.pOD,
      this.pOL,
      this.pickDate,
      this.pickVendor,
      this.taskMemo,
      this.taskStatus,
      this.tractor,
      this.tradeType,
      this.trailer,
      this.vesselorFlight,
      this.wOEquipMode,
      this.wONo,
      this.wOTaskId});

  WOCDetail.fromJson(Map<String, dynamic> json) {
    actualEnd = json['ActualEnd'];
    actualStart = json['ActualStart'];
    bLNo = json['BLNo'];
    cDDate = json['CDDate'];
    cDNo = json['CDNo'];
    custRefNo = json['CustRefNo'];
    driverDesc = json['DriverDesc'];
    driverMobile = json['DriverMobile'];
    equipmentDesc = json['EquipmentDesc'];
    pOD = json['POD'];
    pOL = json['POL'];
    pickDate = json['PickDate'];
    pickVendor = json['PickVendor'];
    taskMemo = json['TaskMemo'];
    taskStatus = json['TaskStatus'];
    tractor = json['Tractor'];
    tradeType = json['TradeType'];
    trailer = json['Trailer'];
    vesselorFlight = json['VesselorFlight'];
    wOEquipMode = json['WOEquipMode'];
    wONo = json['WONo'];
    wOTaskId = json['WOTaskId'];
  }
}

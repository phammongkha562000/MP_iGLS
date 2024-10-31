class PickingItemResponse {
  String? assignedStaff;
  String? clientRefNo;
  String? contactCode;
  String? createDate;
  String? createUser;
  String? dCCode;
  String? eTD;
  String? eTDString;
  String? expiredDate;
  String? expiredDateString;
  double? gIQty;
  String? gRNo;
  String? grade;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? locCode;
  String? lotCode;
  int? oOrdNo;
  String? oOrdType;
  String? ownerShip;
  double? pKQty;
  dynamic productionDate;
  String? productionDateString;
  double? qty;
  int? sBNo;
  int? sKUID;
  int? sRItemNo;
  int? waveItemNo;
  String? waveNo;
  String? zoneCode;

  double? pKPQty;

  PickingItemResponse({
    this.assignedStaff,
    this.clientRefNo,
    this.contactCode,
    this.createDate,
    this.createUser,
    this.dCCode,
    this.eTD,
    this.eTDString,
    this.expiredDate,
    this.expiredDateString,
    this.gIQty,
    this.gRNo,
    this.grade,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.locCode,
    this.lotCode,
    this.oOrdNo,
    this.oOrdType,
    this.ownerShip,
    this.pKQty,
    this.productionDate,
    this.productionDateString,
    this.qty,
    this.sBNo,
    this.sKUID,
    this.sRItemNo,
    this.waveItemNo,
    this.waveNo,
    this.zoneCode,
    this.pKPQty,
  });

  PickingItemResponse.fromJson(Map<String, dynamic> json) {
    assignedStaff = json['AssignedStaff'];
    clientRefNo = json['ClientRefNo'];
    contactCode = json['ContactCode'];
    createDate = json['CreateDate'];
    createUser = json['CreateUser'];
    dCCode = json['DCCode'];
    eTD = json['ETD'];
    eTDString = json['ETDString'];
    expiredDate = json['ExpiredDate'];
    expiredDateString = json['ExpiredDateString'];
    gIQty = double.parse(json['GIQty'].toString());
    gRNo = json['GRNo'];
    grade = json['Grade'];
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    itemStatus = json['ItemStatus'];
    locCode = json['LocCode'];
    lotCode = json['LotCode'];
    oOrdNo = int.parse(json['OOrdNo'].toString());
    oOrdType = json['OOrdType'];
    ownerShip = json['OwnerShip'];
    pKQty = double.parse(json['PKQty'].toString());
    productionDate = json['ProductionDate'];
    productionDateString = json['ProductionDateString'];
    qty = double.parse(json['Qty'].toString());
    sBNo = int.parse(json['SBNo'].toString());
    sKUID = int.parse(json['SKUID'].toString());
    sRItemNo = int.parse(json['SRItemNo'].toString());
    waveItemNo = int.parse(json['WaveItemNo'].toString());
    waveNo = json['WaveNo'];
    zoneCode = json['ZoneCode'];
    pKPQty = double.parse(json['PKPQty'].toString());
  }
}

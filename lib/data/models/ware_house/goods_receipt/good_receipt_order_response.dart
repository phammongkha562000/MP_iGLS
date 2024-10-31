class GoodsReceiptResponse {
  GoodsReceiptResponse({
    this.pageNum,
    this.pageSize,
    this.returnModel,
    this.totalPage,
    this.totalRow,
  });

  int? pageNum;
  int? pageSize;
  List<GoodReceiptOrderResponse>? returnModel;
  int? totalPage;
  int? totalRow;

  factory GoodsReceiptResponse.fromJson(Map<String, dynamic> json) =>
      GoodsReceiptResponse(
        pageNum: json["PageNum"],
        pageSize: json["PageSize"],
        returnModel: List<GoodReceiptOrderResponse>.from(json["ReturnModel"]
            .map((x) => GoodReceiptOrderResponse.fromJson(x))),
        totalPage: json["TotalPage"],
        totalRow: json["TotalRow"],
      );
}

class GoodReceiptOrderResponse {
  GoodReceiptOrderResponse({
    this.assignedStaff,
    this.clientRefNo,
    this.contactCode,
    this.createDate,
    this.createUser,
    this.dcCode,
    this.eta,
    this.expiredDate,
    this.expiredDateString,
    this.grQty,
    this.grade,
    this.iOrdNo,
    this.iOrdType,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.locCode,
    this.lotCode,
    this.ordeId,
    this.ownerShip,
    this.productionDate,
    this.productionDateString,
    this.qty,
    this.skuid,
    this.zoneCode,
  });

  dynamic assignedStaff;
  String? clientRefNo;
  String? contactCode;
  String? createDate;
  String? createUser;
  String? dcCode;
  String? eta;
  String? expiredDate;
  String? expiredDateString;
  double? grQty;
  String? grade;
  int? iOrdNo;
  String? iOrdType;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? locCode;
  String? lotCode;
  int? ordeId;
  String? ownerShip;
  String? productionDate;
  String? productionDateString;
  double? qty;
  int? skuid;
  dynamic zoneCode;

  factory GoodReceiptOrderResponse.fromJson(Map<String, dynamic> json) =>
      GoodReceiptOrderResponse(
        assignedStaff: json["AssignedStaff"],
        clientRefNo: json["ClientRefNo"],
        contactCode: json["ContactCode"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        eta: json["ETA"],
        expiredDate: json["ExpiredDate"],
        expiredDateString: json["ExpiredDateString"],
        grQty: json["GRQty"],
        grade: json["Grade"],
        iOrdNo: json["IOrdNo"],
        iOrdType: json["IOrdType"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"],
        locCode: json["LocCode"],
        lotCode: json["LotCode"],
        ordeId: json["OrdeId"],
        ownerShip: json["OwnerShip"],
        productionDate: json["ProductionDate"],
        productionDateString: json["ProductionDateString"],
        qty: json["Qty"],
        skuid: json["SKUID"],
        zoneCode: json["ZoneCode"],
      );
}

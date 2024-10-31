class InventoryResponse {
  InventoryResponse({
    this.pageNum,
    this.pageSize,
    required this.returnModel,
    this.totalPage,
    this.totalRow,
  });

  int? pageNum;
  int? pageSize;
  List<ReturnModel> returnModel;
  int? totalPage;
  int? totalRow;

  factory InventoryResponse.fromMap(Map<String, dynamic> json) =>
      InventoryResponse(
        pageNum: json["PageNum"],
        pageSize: json["PageSize"],
        returnModel: List<ReturnModel>.from(
            json["ReturnModel"].map((x) => ReturnModel.fromMap(x))),
        totalPage: json["TotalPage"],
        totalRow: json["TotalRow"],
      );
}

class ReturnModel {
  ReturnModel({
    this.availabileQty,
    this.balance,
    this.baseQty,
    this.capacity,
    this.clientRefNo,
    this.contactCode,
    this.createDate,
    this.createUser,
    this.dcCode,
    this.doneByStaff,
    this.expiredDate,
    this.expiredDateVal,
    this.grDate,
    this.grDateVal,
    this.grQty,
    this.grade,
    this.iOrdType,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.locCode,
    this.lotCode,
    this.orderQty,
    this.ownerShip,
    this.productionDate,
    this.productionDateVal,
    this.reservedQty,
    this.sbno,
    this.skuDesc,
    this.skuid,
  });

  double? availabileQty;
  double? balance;
  int? baseQty;
  dynamic capacity;
  String? clientRefNo;
  String? contactCode;
  String? createDate;
  String? createUser;
  String? dcCode;
  String? doneByStaff;
  String? expiredDate;
  String? expiredDateVal;
  String? grDate;
  String? grDateVal;
  double? grQty;
  String? grade;
  String? iOrdType;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? locCode;
  String? lotCode;
  double? orderQty;
  String? ownerShip;
  String? productionDate;
  String? productionDateVal;
  double? reservedQty;
  int? sbno;
  String? skuDesc;
  int? skuid;

  factory ReturnModel.fromMap(Map<String, dynamic> json) => ReturnModel(
        availabileQty: json["AvailabileQty"],
        balance: json["Balance"],
        baseQty: json["BaseQty"],
        capacity: double.parse(json["Capacity"].toString()),
        clientRefNo: json["ClientRefNo"],
        contactCode: json["ContactCode"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        doneByStaff: json["DoneByStaff"],
        expiredDate: json["ExpiredDate"],
        expiredDateVal: json["ExpiredDateVal"],
        grDate: json["GRDate"],
        grDateVal: json["GRDateVal"],
        grQty: json["GRQty"],
        grade: json["Grade"],
        iOrdType: json["IOrdType"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"],
        locCode: json["LocCode"],
        lotCode: json["LotCode"],
        orderQty: json["OrderQty"],
        ownerShip: json["OwnerShip"],
        productionDate: json["ProductionDate"],
        productionDateVal: json["ProductionDateVal"],
        reservedQty: json["ReservedQty"],
        sbno: json["SBNO"],
        skuDesc: json["SKUDesc"],
        skuid: json["SKUID"],
      );
}

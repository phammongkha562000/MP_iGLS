class CustomerInventoryRes {
  double? availabileQty;
  double? balance;
  String? clientRefNo;
  String? createDate;
  String? dcCode;
  String? expiredDate;
  double? grQty;
  String? grade;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? itemStatusDesc;
  String? locCode;
  double? orderQty;
  String? productionDate;
  double? reservedQty;
  int? sbno;
  int? skuid;
  double? volume;
  double? weight;

  CustomerInventoryRes({
    this.availabileQty,
    this.balance,
    this.clientRefNo,
    this.createDate,
    this.dcCode,
    this.expiredDate,
    this.grQty,
    this.grade,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.itemStatusDesc,
    this.locCode,
    this.orderQty,
    this.productionDate,
    this.reservedQty,
    this.sbno,
    this.skuid,
    this.volume,
    this.weight,
  });

  factory CustomerInventoryRes.fromJson(Map<String, dynamic> json) =>
      CustomerInventoryRes(
        availabileQty: json["AvailabileQty"].toDouble(),
        balance: json["Balance"].toDouble(),
        clientRefNo: json["ClientRefNo"],
        createDate: json["CreateDate"],
        dcCode: json["DCCode"],
        expiredDate: json["ExpiredDate"],
        grQty: json["GRQty"].toDouble(),
        grade: json["Grade"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"]!,
        itemStatusDesc: json["ItemStatusDesc"],
        locCode: json["LocCode"],
        orderQty: json["OrderQty"].toDouble(),
        productionDate: json["ProductionDate"],
        reservedQty: json["ReservedQty"].toDouble(),
        sbno: json["SBNO"],
        skuid: json["SKUID"],
        volume: json["Volume"]?.toDouble(),
        weight: json["Weight"]?.toDouble(),
      );
}

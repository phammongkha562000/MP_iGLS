class CustomerInventoryTotalRes {
  String? dcCode;
  String? grade;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? itemStatusDesc;
  double? totalAvailabileQty;
  double? totalBalance;
  double? totalGrQty;
  double? totalOrderQty;
  double? totalReservedQty;

  CustomerInventoryTotalRes({
    this.dcCode,
    this.grade,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.itemStatusDesc,
    this.totalAvailabileQty,
    this.totalBalance,
    this.totalGrQty,
    this.totalOrderQty,
    this.totalReservedQty,
  });

  factory CustomerInventoryTotalRes.fromJson(Map<String, dynamic> json) =>
      CustomerInventoryTotalRes(
        dcCode: json["DCCode"],
        grade: json["Grade"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"],
        itemStatusDesc: json["ItemStatusDesc"],
        totalAvailabileQty: json["TotalAvailabileQty"],
        totalBalance: json["TotalBalance"],
        totalGrQty: json["TotalGRQty"],
        totalOrderQty: json["TotalOrderQty"],
        totalReservedQty: json["TotalReservedQty"],
      );

  
}

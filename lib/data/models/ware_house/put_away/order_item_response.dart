class OrderForPwResponse {
  int? pageNum;
  int? pageSize;
  List<OrderItem>? returnModel;
  int? totalPage;
  int? totalRow;

  OrderForPwResponse({
    this.pageNum,
    this.pageSize,
    this.returnModel,
    this.totalPage,
    this.totalRow,
  });

  factory OrderForPwResponse.fromJson(Map<String, dynamic> json) =>
      OrderForPwResponse(
        pageNum: json["PageNum"],
        pageSize: json["PageSize"],
        returnModel: json["ReturnModel"] == null
            ? []
            : List<OrderItem>.from(
                json["ReturnModel"]!.map((x) => OrderItem.fromJson(x))),
        totalPage: json["TotalPage"],
        totalRow: json["TotalRow"],
      );
}

class OrderItem {
  String? clientRefNo;
  String? grNo;
  String? grade;
  int? iOrdNo;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? locCode;
  String? lotCode;
  double? pwQty;
  double? qty;

  OrderItem({
    this.clientRefNo,
    this.grNo,
    this.grade,
    this.iOrdNo,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.locCode,
    this.lotCode,
    this.pwQty,
    this.qty,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        clientRefNo: json["ClientRefNo"],
        grNo: json["GRNo"],
        grade: json["Grade"],
        iOrdNo: json["IOrdNo"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"],
        locCode: json["LocCode"],
        lotCode: json["LotCode"],
        pwQty: json["PWQty"],
        qty: json["Qty"],
      );
}

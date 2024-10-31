class CustomerOOSRes {
  double? codAmount;
  String? clientRefNo;
  String? createDate;
  String? dcCode;
  dynamic eta;
  String? etd;
  double? giQty;
  int? grQty;
  dynamic grade;
  String? isUse;
  dynamic itemCode;
  dynamic itemDesc;
  String? ordStatusName;
  int? ordeId;
  String? orderTypeDesc;
  String? processStatus;
  double? qty;
  dynamic refno;
  String? receiptDate;

  CustomerOOSRes({
    this.codAmount,
    this.clientRefNo,
    this.createDate,
    this.dcCode,
    this.eta,
    this.etd,
    this.giQty,
    this.grQty,
    this.grade,
    this.isUse,
    this.itemCode,
    this.itemDesc,
    this.ordStatusName,
    this.ordeId,
    this.orderTypeDesc,
    this.processStatus,
    this.qty,
    this.refno,
    this.receiptDate,
  });

  factory CustomerOOSRes.fromJson(Map<String, dynamic> json) => CustomerOOSRes(
        codAmount: json["CODAmount"],
        clientRefNo: json["ClientRefNo"],
        createDate: json["CreateDate"],
        dcCode: json["DCCode"],
        eta: json["ETA"],
        etd: json["ETD"],
        giQty: json["GIQty"],
        grQty: json["GRQty"],
        grade: json["Grade"],
        isUse: json["IsUse"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        ordStatusName: json["OrdStatusName"],
        ordeId: json["OrdeId"],
        orderTypeDesc: json["OrderTypeDesc"],
        processStatus: json["ProcessStatus"],
        qty: json["Qty"],
        refno: json["REFNO"],
        receiptDate: json["ReceiptDate"],
      );
}

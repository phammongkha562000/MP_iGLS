class GetInboundOrderRes {
  int? cODAmount;
  String? clientRefNo;
  String? createDate;
  String? dCCode;
  String? eTA;
  dynamic eTD;
  int? gIQty;
  double? gRQty;
  String? grade;
  String? isUse;
  String? itemCode;
  String? itemDesc;
  String? ordStatusName;
  int? ordeId;
  String? orderTypeDesc;
  String? processStatus;
  double? qty;
  dynamic rEFNO;
  String? receiptDate;

  GetInboundOrderRes(
      {this.cODAmount,
      this.clientRefNo,
      this.createDate,
      this.dCCode,
      this.eTA,
      this.eTD,
      this.gIQty,
      this.gRQty,
      this.grade,
      this.isUse,
      this.itemCode,
      this.itemDesc,
      this.ordStatusName,
      this.ordeId,
      this.orderTypeDesc,
      this.processStatus,
      this.qty,
      this.rEFNO,
      this.receiptDate});

  GetInboundOrderRes.fromJson(Map<String, dynamic> json) {
    cODAmount = json['CODAmount'];
    clientRefNo = json['ClientRefNo'];
    createDate = json['CreateDate'];
    dCCode = json['DCCode'];
    eTA = json['ETA'];
    eTD = json['ETD'];
    gIQty = json['GIQty'];
    gRQty = json['GRQty'];
    grade = json['Grade'];
    isUse = json['IsUse'];
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    ordStatusName = json['OrdStatusName'];
    ordeId = json['OrdeId'];
    orderTypeDesc = json['OrderTypeDesc'];
    processStatus = json['ProcessStatus'];
    qty = json['Qty'];
    rEFNO = json['REFNO'];
    receiptDate = json['ReceiptDate'];
  }
}

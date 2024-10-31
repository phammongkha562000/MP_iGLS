class PalletRelocationResponse {
  double? balanceQty;
  String? clientRefNo;
  String? expiredDate;
  String? expiredDateString;
  String? gRNo;
  double? gRQty;
  String? grade;
  int? iOrdNo;
  String? initialGRNo;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? locCode;
  String? lotCode;
  String? productionDate;
  String? productionDateString;

  PalletRelocationResponse(
      {this.balanceQty,
      this.clientRefNo,
      this.expiredDate,
      this.expiredDateString,
      this.gRNo,
      this.gRQty,
      this.grade,
      this.iOrdNo,
      this.initialGRNo,
      this.itemCode,
      this.itemDesc,
      this.itemStatus,
      this.locCode,
      this.lotCode,
      this.productionDate,
      this.productionDateString});

  PalletRelocationResponse.fromJson(Map<String, dynamic> json) {
    balanceQty = (json['BalanceQty'] as double);
    clientRefNo = json['ClientRefNo'] as String;
    expiredDate = json['ExpiredDate'];
    expiredDateString = json['ExpiredDateString'];
    gRNo = json['GRNo'];
    gRQty = json['GRQty'];
    grade = json['Grade'];
    iOrdNo = json['IOrdNo'];
    initialGRNo = json['InitialGRNo'];
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    itemStatus = json['ItemStatus'];
    locCode = json['LocCode'];
    lotCode = json['LotCode'];
    productionDate = json['ProductionDate'];
    productionDateString = json['ProductionDateString'];
  }
}

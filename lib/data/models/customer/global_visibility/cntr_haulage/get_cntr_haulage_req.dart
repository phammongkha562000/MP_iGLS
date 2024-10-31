class GetCntrHaulageReq {
  String? tradeType;
  String? contactCode;
  String? dATEF;
  String? dATET;
  String? vessel;
  String? pOD;
  String? pOL;
  String? cNTRNo;
  String? bLNo;
  String? mBLNo;
  String? carrierBCNo;
  String? transportType;
  String? dateType;
  String? branchCode;
  String? wOStatus;
  String? itemCode;
  String? invNo;
  String? cDNo;
  String? pONo;

  GetCntrHaulageReq(
      {this.tradeType,
      this.contactCode,
      this.dATEF,
      this.dATET,
      this.vessel,
      this.pOD,
      this.pOL,
      this.cNTRNo,
      this.bLNo,
      this.mBLNo,
      this.carrierBCNo,
      this.transportType,
      this.dateType,
      this.branchCode,
      this.wOStatus,
      this.itemCode,
      this.invNo,
      this.cDNo,
      this.pONo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TradeType'] = tradeType;
    data['ContactCode'] = contactCode;
    data['DATEF'] = dATEF;
    data['DATET'] = dATET;
    data['Vessel'] = vessel;
    data['POD'] = pOD;
    data['POL'] = pOL;
    data['CNTRNo'] = cNTRNo;
    data['BLNo'] = bLNo;
    data['MBLNo'] = mBLNo;
    data['CarrierBCNo'] = carrierBCNo;
    data['TransportType'] = transportType;
    data['DateType'] = dateType;
    data['BranchCode'] = branchCode;
    data['WOStatus'] = wOStatus;
    data['ItemCode'] = itemCode;
    data['InvNo'] = invNo;
    data['CDNo'] = cDNo;
    data['PONo'] = pONo;
    return data;
  }
}

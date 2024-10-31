class GetCntrAgeingReq {
  String? contactCode;
  String? tradeType;
  String? reportType;

  GetCntrAgeingReq({this.contactCode, this.tradeType, this.reportType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ContactCode'] = contactCode;
    data['TradeType'] = tradeType;
    data['ReportType'] = reportType;
    return data;
  }
}

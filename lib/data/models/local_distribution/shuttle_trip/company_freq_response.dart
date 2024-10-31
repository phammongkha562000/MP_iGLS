class CompanyFreqResponse {
  CompanyFreqResponse({this.companyCode, this.companyId, this.companyName});

  String? companyCode;
  String? companyId;
  String? companyName;

  factory CompanyFreqResponse.fromJson(Map<String, dynamic> json) =>
      CompanyFreqResponse(
        companyCode: json["CompanyCode"],
        companyId: json["CompanyId"],
        companyName: json["CompanyName"],
      );
}

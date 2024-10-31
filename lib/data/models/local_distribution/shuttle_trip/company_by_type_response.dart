class CompanyResponse {
  CompanyResponse({
    this.companyCode,
    this.companyId,
    this.companyName,
    this.companyType,
  });

  String? companyCode;
  String? companyId;
  String? companyName;
  String? companyType;

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      CompanyResponse(
        companyCode: json["CompanyCode"],
        companyId: json["CompanyId"],
        companyName: json["CompanyName"],
        companyType: json["CompanyType"],
      );
}

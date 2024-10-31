class CustomerCompanyRes {
  String? companyCode;
  String? companyId;
  String? companyName;
  String? companyType;

  CustomerCompanyRes({
    this.companyCode,
    this.companyId,
    this.companyName,
    this.companyType,
  });

  factory CustomerCompanyRes.fromJson(Map<String, dynamic> json) =>
      CustomerCompanyRes(
        companyCode: json["CompanyCode"],
        companyId: json["CompanyId"],
        companyName: json["CompanyName"],
        companyType: json["CompanyType"],
      );
}

class GetCompanysbyTypeRequest {
  GetCompanysbyTypeRequest({
    required this.contactCode,
    required this.companyCode,
    required this.companyName,
    required this.companyType,
  });

  final String contactCode;
  final String companyCode;
  final String companyName;
  final String companyType;

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "CompanyCode": companyCode,
        "CompanyName": companyName,
        "CompanyType": companyType,
      };
}

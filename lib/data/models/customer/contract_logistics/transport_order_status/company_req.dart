class CustomerCompanyReq {
  final String companyCode;
  final String companyName;
  final String companyType;
  final String contactCode;

  CustomerCompanyReq({
    required this.companyCode,
    required this.companyName,
    required this.companyType,
    required this.contactCode,
  });

  Map<String, dynamic> toJson() => {
        "CompanyCode": companyCode,
        "CompanyName": companyName,
        "CompanyType": companyType,
        "ContactCode": contactCode,
      };
}

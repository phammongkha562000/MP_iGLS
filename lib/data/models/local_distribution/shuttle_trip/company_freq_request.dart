class CompanyFreqRequest {
  CompanyFreqRequest({
    required this.driverId,
    required this.dcCode,
    required this.contactCode,
    required this.companyType,
  });

  final String driverId;
  final String dcCode;
  final String contactCode;
  final String companyType;

  Map<String, dynamic> toJson() => {
        "DriverId": driverId,
        "DCCode": dcCode,
        "ContactCode": contactCode,
        "CompanyType": companyType,
      };
}

class CustomerHaulageOverviewReq {
  final String company;
  final String contactCode;
  final String branchCode;
  final String dataType;
  final String date;

  CustomerHaulageOverviewReq(
      {required this.company,
      required this.contactCode,
      required this.branchCode,
      required this.dataType,
      required this.date});

  Map<String, dynamic> toJson() => {
        "Company": company,
        "ContactCode": contactCode,
        "BranchCode": branchCode,
        "DataType": dataType,
        "Date": date,
      };
}

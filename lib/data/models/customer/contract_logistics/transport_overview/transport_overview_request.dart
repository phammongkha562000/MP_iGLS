class CustomerTransportOverviewReq {
  final String company;
  final String contactCode;
  final String dcCode;
  final int dataType;

  CustomerTransportOverviewReq({
    required this.company,
    required this.contactCode,
    required this.dcCode,
    required this.dataType,
  });

  Map<String, dynamic> toJson() => {
        "Company": company,
        "ContactCode": contactCode,
        "DCCode": dcCode,
        "DataType": dataType,
      };
}

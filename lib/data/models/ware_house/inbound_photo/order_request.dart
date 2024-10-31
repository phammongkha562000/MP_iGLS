class OrderInboundPhotoRequest {
  final String orderNo;
  final String orderType;
  final String etaf;
  final String etat;
  final String aignedStaff;
  final String contactCode;
  final String dcCode;
  final String companyId;
  final int? pageNumber;
  final int? pageSize;

  OrderInboundPhotoRequest({
    required this.orderNo,
    required this.orderType,
    required this.etaf,
    required this.etat,
    required this.aignedStaff,
    required this.contactCode,
    required this.dcCode,
    required this.companyId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'OrderNo': orderNo,
      'OrderType': orderType,
      'ETAF': etaf,
      'ETAT': etat,
      'AssignedStaff': aignedStaff,
      'ContactCode': contactCode,
      'DCNo': dcCode,
      'CompanyId': companyId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
  }
}

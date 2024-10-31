class PutAwayItemRequest {
  final String orderNo;
  final String grdf;
  final String grdt;
  final String grNo;
  final String orderType;
  final String assignedStaff;
  final String contactCode;
  final String dcCode;
  final String companyId;
  final int pageNumber;
  final int pageSize;
  PutAwayItemRequest({
    required this.orderNo,
    required this.grdf,
    required this.grdt,
    required this.grNo,
    required this.orderType,
    required this.assignedStaff,
    required this.contactCode,
    required this.dcCode,
    required this.companyId,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'OrderNo': orderNo,
      'GRDF': grdf,
      'GRDT': grdt,
      'GRNo': grNo,
      'OrderType': orderType,
      'AssignedStaff': assignedStaff,
      'ContactCode': contactCode,
      'DCNo': dcCode,
      'CompanyId': companyId,
      'pageNum': pageNumber,
      'pageSize': pageSize,
    };
  }
}

class RelocationRequest {
  RelocationRequest({
    required this.contactCode,
    required this.dcCode,
    required this.dateFrom,
    required this.dateTo,
    required this.itemCode,
    required this.pageNumber,
    required this.pageSize,
  });

  final String contactCode;
  final String dcCode;
  final String dateFrom;
  final String dateTo;
  final String itemCode;
  final int pageNumber;
  final int pageSize;

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DCCode": dcCode,
        "DateFrom": dateFrom,
        "DateTo": dateTo,
        "ItemCode": itemCode,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
}

class CustomerInventoryReq {
  final String contactCode;
  final String dcNo;
  final String grf;
  final String grt;
  final String grade;
  final String isSummary;
  final String itemCode;
  final String itemStatus;

  CustomerInventoryReq({
    required this.contactCode,
    required this.dcNo,
    required this.grf,
    required this.grt,
    required this.grade,
    required this.isSummary,
    required this.itemCode,
    required this.itemStatus,
  });

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DCNo": dcNo,
        "GRF": grf,
        "GRT": grt,
        "Grade": grade,
        "IsSummary": isSummary,
        "ItemCode": itemCode,
        "ItemStatus": itemStatus,
      };
}

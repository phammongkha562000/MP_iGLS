class InventoryRequest {
  InventoryRequest({
    required this.contactCode,
    required this.companyId,
    required this.dcNo,
    this.itemCode,
    this.locCode,
    this.orderNo,
    this.grf,
    this.grt,
    this.orderType,
    this.donebyStaff,
    this.lotCode,
    this.grade,
    this.zone,
    this.pageNum,
    this.pageSize,
    this.itemStatus,
  });

  String contactCode;
  String companyId;
  String dcNo;
  String? itemCode;
  String? locCode;
  String? orderNo;
  String? grf;
  String? grt;
  String? orderType;
  String? donebyStaff;
  String? lotCode;
  String? grade;
  String? zone;
  int? pageNum;
  int? pageSize;
  String? itemStatus;


  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "CompanyId": companyId,
        "DCNo": dcNo,
        "ItemCode": itemCode,
        "LocCode": locCode,
        "OrderNo": orderNo,
        "GRF": grf,
        "GRT": grt,
        "OrderType": orderType,
        "DonebyStaff": donebyStaff,
        "LOTCode": lotCode,
        "Grade": grade,
        "Zone": zone,
        "pageNum": pageNum,
        "pageSize": pageSize,
        "ItemStatus": itemStatus,
      };
}

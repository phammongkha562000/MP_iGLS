class CustomerOOSReq {
  final String contactCode;
  final String dcNo;
  final String dateF;
  final String dateT;
  final String dateTypeSearch;
  final String isViewDetail;
  final String orderNo;
  final String orderStatus;

  CustomerOOSReq({
    required this.contactCode,
    required this.dcNo,
    required this.dateF,
    required this.dateT,
    required this.dateTypeSearch,
    required this.isViewDetail,
    required this.orderNo,
    required this.orderStatus,
  });  

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DCNo": dcNo,
        "DateF": dateF,
        "DateT": dateT,
        "DateTypeSearch": dateTypeSearch,
        "IsViewDetail": isViewDetail,
        "OrderNo": orderNo,
        "OrderStatus": orderStatus,
      };
}

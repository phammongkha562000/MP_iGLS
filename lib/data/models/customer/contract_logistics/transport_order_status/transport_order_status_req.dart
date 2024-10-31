class CustomerTOSReq {
  final String contactCode;
  final String dcNo;
  final String dateF;
  final String dateT;
  final String orderNo;
  final String orderStatus;
  final String pickUp;
  final String shipTo;
  final String tripNo;

  CustomerTOSReq({
    required this.contactCode,
    required this.dcNo,
    required this.dateF,
    required this.dateT,
    required this.orderNo,
    required this.orderStatus,
    required this.pickUp,
    required this.shipTo,
    required this.tripNo,
  });

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DCNo": dcNo,
        "DateF": dateF,
        "DateT": dateT,
        "OrderNo": orderNo,
        "OrderStatus": orderStatus,
        "PickUp": pickUp,
        "ShipTo": shipTo,
        "TripNo": tripNo,
      };
}

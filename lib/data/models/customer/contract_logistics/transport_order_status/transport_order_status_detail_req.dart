class CustomerTOSDetailReq {
  final String contactCode;
  final String deliveryMode;
  final String orderId;
  final String tripNo;

  CustomerTOSDetailReq({
    required this.contactCode,
    required this.deliveryMode,
    required this.orderId,
    required this.tripNo,
  });

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DeliveryMode": deliveryMode,
        "OrderId": orderId,
        "TripNo": tripNo,
      };
}

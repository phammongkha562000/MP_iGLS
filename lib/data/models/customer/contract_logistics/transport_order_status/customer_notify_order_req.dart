class CustomerNotifyOrderReq {
  final String orderId;
  final String tripNo;

  CustomerNotifyOrderReq({
    required this.orderId,
    required this.tripNo,
  });

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "TripNo": tripNo,
      };
}

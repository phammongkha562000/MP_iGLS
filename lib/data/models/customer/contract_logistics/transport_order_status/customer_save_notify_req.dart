class CustomerSaveNotifyReq {
  final String messageType;
  final String notes;
  final String orderId;
  final String receiver;
  final String tripNo;
  final String userId;

  CustomerSaveNotifyReq({
    required this.messageType,
    required this.notes,
    required this.orderId,
    required this.receiver,
    required this.tripNo,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "MessageType": messageType,
        "Notes": notes,
        "OrderId": orderId,
        "Receiver": receiver,
        "TripNo": tripNo,
        "UserId": userId,
      };
}

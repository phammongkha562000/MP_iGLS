class CustomerNotifyOrderRes {
  String? createDate;
  String? createUser;
  int? id;
  String? messageType;
  String? notes;
  int? orderId;
  String? receiver;
  String? tripNo;
  String? updateDate;

  CustomerNotifyOrderRes({
    this.createDate,
    this.createUser,
    this.id,
    this.messageType,
    this.notes,
    this.orderId,
    this.receiver,
    this.tripNo,
    this.updateDate,
  });

  factory CustomerNotifyOrderRes.fromJson(Map<String, dynamic> json) =>
      CustomerNotifyOrderRes(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        id: json["Id"],
        messageType: json["MessageType"],
        notes: json["Notes"],
        orderId: json["OrderId"],
        receiver: json["Receiver"],
        tripNo: json["TripNo"],
        updateDate: json["UpdateDate"],
      );
}

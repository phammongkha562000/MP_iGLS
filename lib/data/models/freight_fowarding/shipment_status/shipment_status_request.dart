class ShipmentStatusRequest {
  ShipmentStatusRequest({
    required this.blNo,
    required this.contactCode,
    required this.date,
    required this.cntrNo,
  });

  String blNo;
  String contactCode;
  String date;
  String cntrNo;

  Map<String, dynamic> toMap() => {
        "BLNo": blNo,
        "ContactCode": contactCode,
        "Date": date,
        "CNTRNo": cntrNo,
      };
}

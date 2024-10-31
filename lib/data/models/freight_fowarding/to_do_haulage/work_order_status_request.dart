class WorkOrderStatusRequest {
  int wOTaskId;
  String eventDate;
  String eventType;
  String lat;
  String lon;
  String userId;
  String cNTRNo;
  String sealNo;
  WorkOrderStatusRequest({
    required this.wOTaskId,
    required this.eventDate,
    required this.eventType,
    required this.lat,
    required this.lon,
    required this.userId,
    required this.cNTRNo,
    required this.sealNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'WOTaskId': wOTaskId,
      'EventDate': eventDate,
      'EventType': eventType,
      'Lat': lat,
      'Lon': lon,
      'UserId': userId,
      'CNTRNo': cNTRNo,
      'SealNo': sealNo,
    };
  }
}

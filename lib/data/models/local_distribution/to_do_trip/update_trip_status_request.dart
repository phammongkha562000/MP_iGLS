class UpdateTripStatusRequest {
  final String tripNo;
  final String eventDate;
  final String eventType;
  final double lon;
  final double lat;
  final String userId;
  final String deliveryResult;
  final String failReason;
  final String remark;
  final int orgItemNo;
  final int orderId;
  UpdateTripStatusRequest({
    required this.tripNo,
    required this.eventDate,
    required this.eventType,
    required this.lon,
    required this.lat,
    required this.userId,
    required this.deliveryResult,
    required this.failReason,
    required this.remark,
    required this.orgItemNo,
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'TripNo': tripNo,
      'EventDate': eventDate,
      'EventType': eventType,
      'Lon': lon,
      'Lat': lat,
      'UserId': userId,
      'DeliveryResult': deliveryResult,
      'FailReason': failReason,
      'Remark': remark,
      'OrgItemNo': orgItemNo,
      'OrderId': orderId,
    };
  }
}

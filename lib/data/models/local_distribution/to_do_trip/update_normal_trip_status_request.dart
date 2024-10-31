class UpdateNormalTripStatusRequest {
  final String tripNo;
  final String eventDate;
  final String eventType;
  final String placeDesc;
  final String remark;
  final String longitude;
  final String latitude;
  final String userId;
  final int ordeId;
  UpdateNormalTripStatusRequest({
    required this.tripNo,
    required this.eventDate,
    required this.eventType,
    required this.placeDesc,
    required this.remark,
    required this.longitude,
    required this.latitude,
    required this.userId,
    required this.ordeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'TripNo': tripNo,
      'EventDate': eventDate,
      'EventType': eventType,
      'PlaceDesc': placeDesc,
      'Remark': remark,
      'Longitude': longitude,
      'Latitude': latitude,
      'UserId': userId,
      'OrdeId': ordeId,
    };
  }
}

class UpdateNormalTripStatusOrgItemRequest {
  final String tripNo;
  final String eventDate;
  final String eventType;
  final String placeDesc;
  final String remark;
  final String longitude;
  final String latitude;
  final String userId;
  final int orgItemNo;
  final String companyId;
  UpdateNormalTripStatusOrgItemRequest({
    required this.tripNo,
    required this.eventDate,
    required this.eventType,
    required this.placeDesc,
    required this.remark,
    required this.longitude,
    required this.latitude,
    required this.userId,
    required this.orgItemNo,
    required this.companyId,
  });

  //

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
      'OrgItemNo': orgItemNo,
      'CompanyId': companyId,
    };
  }
}

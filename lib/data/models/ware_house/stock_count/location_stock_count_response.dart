class LocationStockCountResponse {
  LocationStockCountResponse({
    this.dcCode,
    this.locCode,
    this.locDesc,
    this.locType,
    this.zoneCode,
  });

  String? dcCode;
  String? locCode;
  String? locDesc;
  String? locType;
  String? zoneCode;

  factory LocationStockCountResponse.fromMap(Map<String, dynamic> json) =>
      LocationStockCountResponse(
        dcCode: json["DCCode"],
        locCode: json["LocCode"],
        locDesc: json["LocDesc"],
        locType: json["LocType"],
        zoneCode: json["ZoneCode"],
      );
}

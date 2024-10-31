class SiteStockCheckRequest {
  String? trailerNumber;
  String? placeSite;
  String? placeSiteName;
  String? userId;
  String? remark;
  String? lat;
  String? lon;
  String? tireStatus;
  String? ledStatus;
  String? cntrNo;
  String? countTrailer;
  String? cntrStatus;
  String? barriers;
  String? containerLocker;
  String? landingGear;
  String? createDate;
  String? equipTypeDesc;
  String? workingStatus;
  SiteStockCheckRequest({
    this.trailerNumber,
    this.placeSite,
    this.placeSiteName,
    this.userId,
    this.remark,
    this.lat,
    this.lon,
    this.tireStatus,
    this.ledStatus,
    this.cntrNo,
    this.countTrailer,
    this.cntrStatus,
    this.barriers,
    this.containerLocker,
    this.landingGear,
    this.createDate,
    this.equipTypeDesc,
    this.workingStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'TrailerNumber': trailerNumber,
      'PlaceSite': placeSite,
      'PlaceSiteName': placeSiteName,
      'UserId': userId,
      'Remark': remark,
      'LAT': lat,
      'LON': lon,
      'TireStatus': tireStatus,
      'LEDStatus': ledStatus, //lưu ý hoa thường
      'CNTRNo': cntrNo,
      'CountTrailer': countTrailer,
      'CNTRStatus': cntrStatus,
      'Barriers': barriers,
      'ContainerLocker': containerLocker,
      'LandingGear': landingGear,
      'CreateDate': createDate,
      'EquipTypeDesc': equipTypeDesc,
      'WorkingStatus': workingStatus,
    };
  }

  factory SiteStockCheckRequest.fromMap(Map<String, dynamic> map) {
    return SiteStockCheckRequest(
      trailerNumber: map['TrailerNumber'],
      placeSite: map['PlaceSite'],
      placeSiteName: map['PlaceSiteName'],
      userId: map['UserId'],
      remark: map['Remark'],
      lat: map['LAT'],
      lon: map['LON'],
      tireStatus: map['TireStatus'],
      ledStatus: map['LedStatus'], //lưu ý hoa thường
      cntrNo: map['CNTRNo'],
      countTrailer: map['CountTrailer'],
      cntrStatus: map['CNTRStatus'],
      barriers: map['Barriers'],
      containerLocker: map['ContainerLocker'],
      landingGear: map['LandingGear'],
      createDate: map['CreateDate'],
      equipTypeDesc: map['EquipTypeDesc'],
      workingStatus: map['WorkingStatus'],
    );
  }
}

class TrailerSearchRequest {
  final String dateF;
  final String dateT;
  final String trailerNumber;
  final String placeSite;
  final String cntrNo;
  final String? dcCode;
  TrailerSearchRequest({
    required this.dateF,
    required this.dateT,
    required this.trailerNumber,
    required this.placeSite,
    required this.cntrNo,
    this.dcCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DateF': dateF,
      'DateT': dateT,
      'TrailerNumber': trailerNumber,
      'PlaceSite': placeSite,
      'CNTRNo': cntrNo,
      'DCCode': dcCode
    };
  }
}

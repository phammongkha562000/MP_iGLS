class SiteStockSummaryRequest {
  final String dateF;
  final String dateT;
  final String trailerNumber;
  final String placeSite;
  final String cntrNo;

  SiteStockSummaryRequest({
    required this.dateF,
    required this.dateT,
    required this.trailerNumber,
    required this.placeSite,
    required this.cntrNo,
  });

  Map<String, dynamic> toJson() => {
        "DateF": dateF,
        "DateT": dateT,
        "TrailerNumber": trailerNumber,
        "PlaceSite": placeSite,
        "CNTRNo": cntrNo,
      };
}

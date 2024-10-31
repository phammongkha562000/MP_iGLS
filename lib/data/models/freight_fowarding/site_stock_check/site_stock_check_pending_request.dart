class SiteStockCheckPendingRequest {
  final String dateF;
  final String dateT;
  final String dcCode;

  SiteStockCheckPendingRequest({
    required this.dateF,
    required this.dateT,
    required this.dcCode,
  });

  Map<String, dynamic> toJson() => {
        "DateF": dateF,
        "DateT": dateT,
        "DCCode": dcCode,
      };
}

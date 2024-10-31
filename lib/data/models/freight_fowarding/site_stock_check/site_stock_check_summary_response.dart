class SiteStockSummaryResponse {
  String? cyName;
  int? empty;
  int? loaded;
  int? total;

  SiteStockSummaryResponse({
    this.cyName,
    this.empty,
    this.loaded,
    this.total,
  });

  factory SiteStockSummaryResponse.fromJson(Map<String, dynamic> json) =>
      SiteStockSummaryResponse(
        cyName: json["CYName"],
        empty: json["Empty"],
        loaded: json["Loaded"],
        total: json["Total"],
      );
}

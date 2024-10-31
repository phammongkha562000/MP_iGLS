class CySiteResponse {
  CySiteResponse({
    this.cyCode,
    this.cyName,
  });

  String? cyCode;
  String? cyName;

  factory CySiteResponse.fromJson(Map<String, dynamic> json) => CySiteResponse(
        cyCode: json["CYCode"],
        cyName: json["CYName"],
      );
}

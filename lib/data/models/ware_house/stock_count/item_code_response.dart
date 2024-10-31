class ItemCodeResponse {
  ItemCodeResponse({
    this.itemCode,
    this.itemDesc,
    this.itemId,
  });

  String? itemCode;
  String? itemDesc;
  String? itemId;

  factory ItemCodeResponse.fromJson(Map<String, dynamic> json) =>
      ItemCodeResponse(
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemId: json["ItemID"],
      );
}

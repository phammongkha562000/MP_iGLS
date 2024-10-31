class SkuResponse {
  int? skuId;
  double? baseQty;
  int? itemId;
  bool? isDefaultSku;
  String? skuDesc;
  String? uom;
  SkuResponse({
    this.skuId,
    this.baseQty,
    this.itemId,
    this.isDefaultSku,
    this.skuDesc,
    this.uom,
  });

  factory SkuResponse.fromMap(Map<String, dynamic> map) {
    return SkuResponse(
      skuId: map['SKUID'] != null ? map['SKUID'] as int : null,
      baseQty: map['BaseQty'] != null ? map['BaseQty'] as double : null,
      itemId: map['ItemID'] != null ? map['ItemID'] as int : null,
      isDefaultSku:
          int.parse(map["IsDefaultSKU"].toString()) == 1 ? true : false,
      skuDesc: map['SKUDesc'] != null ? map['SKUDesc'] as String : null,
      uom: map['UOM'] != null ? map['UOM'] as String : null,
    );
  }
}

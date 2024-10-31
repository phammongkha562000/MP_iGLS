class StockCountResponse {
  String? contactCode;
  String? countCode;
  String? createDate;
  String? createUser;
  String? dcCode;
  int? id;
  String? itemCode;
  int? itemId;
  String? locCode;
  double? qty;
  String? remark;
  int? round;
  String? yyyymm;
  String? uom;
  StockCountResponse(
      this.contactCode,
      this.countCode,
      this.createDate,
      this.createUser,
      this.dcCode,
      this.id,
      this.itemCode,
      this.itemId,
      this.locCode,
      this.qty,
      this.remark,
      this.round,
      this.yyyymm,
      this.uom);

  factory StockCountResponse.fromMap(Map<String, dynamic> map) {
    return StockCountResponse(
      map['ContactCode'],
      map['CountCode'],
      map['CreateDate'],
      map['CreateUser'],
      map['DCCode'],
      map['Id']?.toInt(),
      map['ItemCode'],
      map['ItemId']?.toInt(),
      map['LocCode'],
      map['Qty']?.toDouble(),
      map['Remark'],
      map['Round']?.toInt(),
      map['YYYYMM'],
      map['UOM'],
    );
  }
}

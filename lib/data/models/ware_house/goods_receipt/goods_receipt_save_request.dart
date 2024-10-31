class GoodsReceiptSaveRequest {
  final int iOrdNo;
  final String clientRefNo;
  final String grade;
  final String itemStatus;
  final int skuId;
  final String productionDate;
  final String expiredDate;
  final String lotCode;
  final String locCode;
  final String doneByStaff;
  final String cntrNo;
  final String truckNo;
  final String zoneCode;
  final String eta;
  final double pwQty;
  final bool isSplit;
  final double grQty;
  final String itemCode;
  final String itemDesc;
  final String iOrderType;
  final String createUser;
  final String owenerShip;
  final double baseQty;
  final double qty;
  GoodsReceiptSaveRequest({
    required this.iOrdNo,
    required this.clientRefNo,
    required this.grade,
    required this.itemStatus,
    required this.skuId,
    required this.productionDate,
    required this.expiredDate,
    required this.lotCode,
    required this.locCode,
    required this.doneByStaff,
    required this.cntrNo,
    required this.truckNo,
    required this.zoneCode,
    required this.eta,
    required this.pwQty,
    required this.isSplit,
    required this.grQty,
    required this.itemCode,
    required this.itemDesc,
    required this.iOrderType,
    required this.createUser,
    required this.owenerShip,
    required this.baseQty,
    required this.qty,
  });

  GoodsReceiptSaveRequest copyWith({
    int? iOrdNo,
    String? clientRefNo,
    String? grade,
    String? itemStatus,
    int? skuId,
    String? productionDate,
    String? expiredDate,
    String? lotCode,
    String? locCode,
    String? doneByStaff,
    String? cntrNo,
    String? truckNo,
    String? zoneCode,
    String? eta,
    double? pwQty,
    bool? isSplit,
    double? grQty,
    String? itemCode,
    String? itemDesc,
    String? iOrderType,
    String? createUser,
    String? owenerShip,
    double? baseQty,
    double? qty,
  }) {
    return GoodsReceiptSaveRequest(
      iOrdNo: iOrdNo ?? this.iOrdNo,
      clientRefNo: clientRefNo ?? this.clientRefNo,
      grade: grade ?? this.grade,
      itemStatus: itemStatus ?? this.itemStatus,
      skuId: skuId ?? this.skuId,
      productionDate: productionDate ?? this.productionDate,
      expiredDate: expiredDate ?? this.expiredDate,
      lotCode: lotCode ?? this.lotCode,
      locCode: locCode ?? this.locCode,
      doneByStaff: doneByStaff ?? this.doneByStaff,
      cntrNo: cntrNo ?? this.cntrNo,
      truckNo: truckNo ?? this.truckNo,
      zoneCode: zoneCode ?? this.zoneCode,
      eta: eta ?? this.eta,
      pwQty: pwQty ?? this.pwQty,
      isSplit: isSplit ?? this.isSplit,
      grQty: grQty ?? this.grQty,
      itemCode: itemCode ?? this.itemCode,
      itemDesc: itemDesc ?? this.itemDesc,
      iOrderType: iOrderType ?? this.iOrderType,
      createUser: createUser ?? this.createUser,
      owenerShip: owenerShip ?? this.owenerShip,
      baseQty: baseQty ?? this.baseQty,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'IOrdNo': iOrdNo,
      'ClientRefNo': clientRefNo,
      'Grade': grade,
      'ItemStatus': itemStatus,
      'SKUId': skuId,
      'ProductionDate': productionDate,
      'ExpiredDate': expiredDate,
      'LotCode': lotCode,
      'LocCode': locCode,
      'DoneByStaff': doneByStaff,
      'CNTRNo': cntrNo,
      'TruckNo': truckNo,
      'ZoneCode': zoneCode,
      'ETA': eta,
      'PwQty': pwQty,
      'IsSplit': isSplit,
      'GRQty': grQty,
      'ItemCode': itemCode,
      'ItemDesc': itemDesc,
      'IorderType': iOrderType,
      'CreateUser': createUser,
      'OwenerShip': owenerShip,
      'BaseQty': baseQty,
      'Qty': qty,
    };
  }

 
}

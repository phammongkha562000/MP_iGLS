class AddStockCountRequest {
  AddStockCountRequest({
    required this.contactCode,
    required this.dcCode,
    required this.countCode,
    required this.createUser,
    required this.round,
    required this.locCode,
    required this.itemCode,
    required this.yyyymm,
    required this.qty,
    required this.remark,
    required this.companyId,
    required this.uom,
  });

  final String contactCode;
  final String dcCode;
  final String countCode;
  final String createUser;
  final int round;
  final String locCode;
  final String itemCode;
  final String yyyymm;
  final double qty;
  final String remark;
  final String companyId;
  final String uom;

  Map<String, dynamic> toMap() {
    return {
      'ContactCode': contactCode,
      'DCCode': dcCode,
      'CountCode': countCode,
      'CreateUser': createUser,
      'Round': round,
      'LocCode': locCode,
      'ItemCode': itemCode,
      'YYYYMM': yyyymm,
      'Qty': qty,
      'Remark': remark,
      'CompanyId': companyId,
      'UOM': uom,
    };
  }
}

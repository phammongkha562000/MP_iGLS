class PalletRelocationSaveRequest {
  final String orgGRNo;
  final String orgLocCode;
  final double orgQty;
  final String locCode;
  final double qty;
  final double balanceQty;
  final String createUser;
  final String companyId;
  PalletRelocationSaveRequest({
    required this.orgGRNo,
    required this.orgLocCode,
    required this.orgQty,
    required this.locCode,
    required this.qty,
    required this.balanceQty,
    required this.createUser,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'OrgGRNo': orgGRNo,
      'OrgLocCode': orgLocCode,
      'OrgQty': orgQty,
      'LocCode': locCode,
      'Qty': qty,
      'BalanceQty': balanceQty,
      'CreateUser': createUser,
      'CompanyId': companyId,
    };
  }
}

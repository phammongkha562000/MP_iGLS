class BulkCostApprovalSearchRequest {
  final String contactCode;
  final String tradeType;
  final String reqDateF;
  final String reqDateT;
  final String createUser;
  final String woNo;
  final String blNo;
  final String cntrNo;
  final String paymentMode;
  final String approvalMode;
  final String payToContactCode;
  final String accountCode;
  final String branchCode;
  final int pageNumber;
  final int pageSize;
  BulkCostApprovalSearchRequest({
    required this.contactCode,
    required this.tradeType,
    required this.reqDateF,
    required this.reqDateT,
    required this.createUser,
    required this.woNo,
    required this.blNo,
    required this.cntrNo,
    required this.paymentMode,
    required this.approvalMode,
    required this.payToContactCode,
    required this.accountCode,
    required this.branchCode,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ContactCode': contactCode,
      'TradeType': tradeType,
      'ReqDateF': reqDateF,
      'ReqDateT': reqDateT,
      'CreateUser': createUser,
      'WONo': woNo,
      'BLNo': blNo,
      'CNTRNo': cntrNo,
      'PaymentMode': paymentMode,
      'ApprovalMode': approvalMode,
      'PayToContactCode': payToContactCode,
      'AccountCode': accountCode,
      'BranchCode': branchCode,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
  }
}

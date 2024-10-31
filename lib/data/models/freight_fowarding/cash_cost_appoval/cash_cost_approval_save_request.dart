class CashCostApprovalSaveRequest {
  final String contactCode;
  final String cwoId;
  final String cwoCId;
  final String userId;
  CashCostApprovalSaveRequest({
    required this.contactCode,
    required this.cwoId,
    required this.cwoCId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ContactCode': contactCode,
      'CWOId': cwoId,
      'CWOCId': cwoCId,
      'UserId': userId,
    };
  }
}

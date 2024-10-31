class TransactionReportRequest {
  final String branchCode;
  final String dateF;
  final String dateT;
  final dynamic transactionType;
  final dynamic refDocNo;
  final String staffId;
  final String reportType;
  final String roleType;
  final String dcCode;

  TransactionReportRequest({
    required this.branchCode,
    required this.dateF,
    required this.dateT,
    required this.transactionType,
    required this.refDocNo,
    required this.staffId,
    required this.reportType,
    required this.roleType,
    required this.dcCode,
  });

  Map<String, dynamic> toJson() => {
        "BranchCode": branchCode,
        "DateF": dateF,
        "DateT": dateT,
        "TransactionType": transactionType,
        "RefDocNo": refDocNo,
        "StaffId": staffId,
        "ReportType": reportType,
        "RoleType": roleType,
        "DCCode": dcCode,
      };
}

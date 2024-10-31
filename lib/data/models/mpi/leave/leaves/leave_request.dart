class LeaveRequest {
  LeaveRequest(
      {this.leaveType,
      this.status,
      this.submitDateF,
      this.submitDateT,
      this.employeeCode,
      this.pageNumber,
      this.rowNumber});

  String? leaveType;
  String? status;
  String? submitDateF;
  String? submitDateT;
  String? employeeCode;
  int? pageNumber;
  int? rowNumber;

  Map<String, dynamic> toJson() => {
        "LeaveType": leaveType,
        "Status": status,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "EmployeeCode": employeeCode,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}

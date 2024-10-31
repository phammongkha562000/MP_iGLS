class NewLeaveRequest {
  NewLeaveRequest(
      {required this.employeeCode,
      required this.employeeId,
      required this.fromDate,
      required this.toDate,
      required this.leaveDays,
      required this.leaveStatus,
      required this.leaveType,
      // required this.userId,
      required this.marker,
      required this.remark});

  String employeeCode;
  int? employeeId;
  String fromDate;
  String toDate;
  double leaveDays;
  String leaveStatus;
  String leaveType;
  // int userId;
  String marker;
  String remark;

  Map<String, dynamic> toJson() => {
        "employeeCode": employeeCode,
        "employeeId": employeeId,
        "fromDate": fromDate,
        "toDate": toDate,
        "leaveDays": leaveDays,
        "leaveStatus": leaveStatus,
        "leaveType": leaveType,
        // "userId": userId,
        "marker": marker,
        "remark": remark
      };
}

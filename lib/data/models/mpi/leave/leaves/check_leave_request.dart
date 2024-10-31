class CheckLeaveRequest {
  CheckLeaveRequest({this.leavetype, this.employeeCode, this.lyear});

  String? leavetype;
  // int? employeeId;
  String? employeeCode;
  String? lyear;

  Map<String, dynamic> toJson() =>
      {"leavetype": leavetype, "employeeCode": employeeCode, "lyear": lyear};
}

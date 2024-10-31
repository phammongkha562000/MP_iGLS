class TimesheetsUpdateRequest {
  int tSId;
  String startTime;
  String endTime;
  double workHour;
  double overtTimeHour;
  String manualPostType;
  String manualPostReason;
  String employeeCode;

  TimesheetsUpdateRequest(
      {required this.tSId,
      required this.startTime,
      required this.endTime,
      required this.workHour,
      required this.overtTimeHour,
      required this.manualPostType,
      required this.manualPostReason,
      required this.employeeCode});

  Map<String, dynamic> toJson() => {
        "TSId": tSId,
        "StartTime": startTime,
        "EndTime": endTime,
        "WorkHour": workHour,
        "OvertTimeHour": overtTimeHour,
        "ManualPostType": manualPostType,
        "ManualPostReason": manualPostReason,
        "EmployeeCode": employeeCode,
      };
}

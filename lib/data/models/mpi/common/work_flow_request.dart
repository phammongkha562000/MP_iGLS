class WorkFlowRequest {
  WorkFlowRequest(
      {required this.applicationCode,
      required this.deptCode,
      required this.divisionCode,
      required this.employeeCode,
      required this.empId,
      required this.localAmount,
      required this.subsidiryId});

  String applicationCode;
  String deptCode;
  String divisionCode;
  String employeeCode;
  int localAmount;
  String subsidiryId;
  int empId;

  Map<String, dynamic> toJson() => {
        "ApplicationCode": applicationCode,
        "DeptCode": deptCode,
        "DivisionCode": divisionCode,
        "EmpId": empId,
        "EmployeeCode": employeeCode,
        "LocalAmount": localAmount,
        "SubsidiryID": subsidiryId
      };
}

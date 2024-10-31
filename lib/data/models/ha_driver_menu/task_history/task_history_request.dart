class TaskHistoryRequest {
  final String driverId;
  String? equipmentCode;
  final String status;
  final String taskDate;
  TaskHistoryRequest(
      {required this.driverId,
      this.equipmentCode,
      required this.status,
      required this.taskDate});

  Map<String, dynamic> toJson() {
    return {
      "DriverId": driverId,
      "EquipmentCode": equipmentCode,
      "TaskStatus": status,
      "TaskDate": taskDate
    };
  }
}

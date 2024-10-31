class HistoryTodoRequest {
  final String equipmentCode;
  final String etp;
  final String driverId;
  final int pageNumber;
  final int pageSize;

  HistoryTodoRequest({
    required this.equipmentCode,
    required this.etp,
    required this.driverId,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => {
        "equipmentCode": equipmentCode,
        "etp": etp,
        "driverId": driverId,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
}

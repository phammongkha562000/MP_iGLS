class ListToDoHaulageRequest {
  String dateFrom;
  String dateTo;
  String equipmentCode;
  String isOnlyPending;
  String? driverID;
  int pageNumber;
  int pageSize;
  ListToDoHaulageRequest({
    required this.dateFrom,
    required this.dateTo,
    required this.equipmentCode,
    required this.isOnlyPending,
    this.driverID,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'DateFrom': dateFrom,
      'DateTo': dateTo,
      'EquipmentCode': equipmentCode,
      'IsOnlyPending': isOnlyPending,
      'DriverID': driverID,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
  }
}

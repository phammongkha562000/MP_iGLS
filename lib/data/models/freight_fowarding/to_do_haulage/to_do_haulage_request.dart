class ListToDoHaulageRequest {
  String dateFrom;
  String dateTo;
  String equipmentCode;
  String isOnlyPending;
  String? driverID;
  ListToDoHaulageRequest(
      {required this.dateFrom,
      required this.dateTo,
      required this.equipmentCode,
      required this.isOnlyPending,
      this.driverID});

  ListToDoHaulageRequest copyWith(
      {String? dateFrom,
      String? dateTo,
      String? equipmentCode,
      String? isOnlyPending,
      String? driverID}) {
    return ListToDoHaulageRequest(
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        equipmentCode: equipmentCode ?? this.equipmentCode,
        isOnlyPending: isOnlyPending ?? this.isOnlyPending,
        driverID: driverID ?? this.driverID);
  }

  Map<String, dynamic> toMap() {
    return {
      'DateFrom': dateFrom,
      'DateTo': dateTo,
      'EquipmentCode': equipmentCode,
      'IsOnlyPending': isOnlyPending,
      'DriverID': driverID
    };
  }
}

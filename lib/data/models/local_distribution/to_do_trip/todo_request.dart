class TodoRequest {
  final String equipmentCode;
  final String driverId;
  final String etp;
  final String companyId;
  final int pageNumber;
  final int pageSize;

  TodoRequest({
    required this.equipmentCode,
    required this.driverId,
    required this.etp,
    required this.companyId,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => {
        "equipmentCode": equipmentCode,
        "driverId": driverId,
        "etp": etp,
        "companyId": companyId,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
}

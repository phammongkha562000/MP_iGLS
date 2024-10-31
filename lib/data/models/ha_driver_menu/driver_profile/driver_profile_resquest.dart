class DriverProfileResquest {
  final String userID;
  final String driverName;
  final String phoneNo;
  final String dirverId;
  final String equipmentCode;
  final String contactCode;
  final String dcCode;
  final String cyCode;
  DriverProfileResquest({
    required this.userID,
    required this.driverName,
    required this.phoneNo,
    required this.dirverId,
    required this.equipmentCode,
    required this.contactCode,
    required this.dcCode,
    required this.cyCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'driverName': driverName,
      'phoneNo': phoneNo,
      'dirverId': dirverId,
      'equipmentCode': equipmentCode,
      'contactCode': contactCode,
      'dcCode': dcCode,
      'cyCode': cyCode,
    };
  }
}

class StaffUpdateRequest {
  final String staffUserId;
  final String staffName;
  final String roleType;
  final String dcCode;
  final String updateUser;
  final bool isActive;
  final String mobileNo;
  final String listDcCode;
  final String statusWorking;
  final String driverLicenseNo;
  final String icNo;
  final String vendorCode;
  final String remark;
  final String defaultEquipment;

  StaffUpdateRequest({
    required this.staffUserId,
    required this.staffName,
    required this.roleType,
    required this.dcCode,
    required this.updateUser,
    required this.isActive,
    required this.mobileNo,
    required this.listDcCode,
    required this.statusWorking,
    required this.driverLicenseNo,
    required this.icNo,
    required this.vendorCode,
    required this.remark,
    required this.defaultEquipment,
  });

  Map<String, dynamic> toJson() => {
        "StaffUserId": staffUserId,
        "StaffName": staffName,
        "RoleType": roleType,
        "DCCode": dcCode,
        "CreateUser": updateUser,
        "IsActive": isActive,
        "MobileNo": mobileNo,
        "ListDCCode": listDcCode,
        "StatusWorking": statusWorking,
        "DriverLicenseNo": driverLicenseNo,
        "ICNo": icNo,
        "VendorCode": vendorCode,
        "Remark": remark,
        "DefaultEquipment": defaultEquipment,
      };
}

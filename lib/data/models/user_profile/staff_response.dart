class StaffResponse {
  StaffResponse({
    this.dcCode,
    this.defaultEquipment,
    this.mobileNo,
    this.roleType,
    this.staffName,
    this.staffUserId,
  });

  String? dcCode;
  String? defaultEquipment;
  String? mobileNo;
  String? roleType;
  String? staffName;
  String? staffUserId;

  factory StaffResponse.fromMap(Map<String, dynamic> json) => StaffResponse(
        dcCode: json["DCCode"],
        defaultEquipment: json["DefaultEquipment"],
        mobileNo: json["MobileNo"],
        roleType: json["RoleType"],
        staffName: json["StaffName"],
        staffUserId: json["StaffUserId"],
      );
}

class StaffsResponse {
  String? createDate;
  String? createUser;
  String? dcCode;
  String? defaultEquipment;
  dynamic isUse;
  String? mobileNo;
  String? roleType;
  String? staffName;
  String? staffUserId;
  String? updateDate;
  String? updateUser;

  StaffsResponse({
    this.createDate,
    this.createUser,
    this.dcCode,
    this.defaultEquipment,
    this.isUse,
    this.mobileNo,
    this.roleType,
    this.staffName,
    this.staffUserId,
    this.updateDate,
    this.updateUser,
  });

  factory StaffsResponse.fromJson(Map<String, dynamic> json) => StaffsResponse(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        defaultEquipment: json["DefaultEquipment"],
        isUse: json["IsUse"],
        mobileNo: json["MobileNo"],
        roleType: json["RoleType"],
        staffName: json["StaffName"],
        staffUserId: json["StaffUserId"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}
